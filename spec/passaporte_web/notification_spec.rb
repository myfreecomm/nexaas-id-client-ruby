# encoding: utf-8
require 'spec_helper'

describe PassaporteWeb::Notification do

  describe "constants" do
    it { PassaporteWeb::Notification::ATTRIBUTES.should == [:body, :target_url, :uuid, :absolute_url, :scheduled_to, :sender_data, :read_at, :notification_type, :destination] }
    it { PassaporteWeb::Notification::CREATABLE_ATTRIBUTES.should == [:body, :target_url, :scheduled_to, :destination] }
  end

  describe ".new" do
    it "should instanciate an empty object" do
      notification = PassaporteWeb::Notification.new
      notification.should_not be_persisted
      notification.attributes.should == {}
      notification.uuid.should be_nil
      notification.destination.should be_nil
      notification.body.should be_nil
      notification.target_url.should be_nil
      notification.scheduled_to.should be_nil
      notification.absolute_url.should be_nil
      notification.sender_data.should be_nil
      notification.read_at.should be_nil
      notification.notification_type.should be_nil
    end
    it "should instanciate an object with attributes set" do
      attributes = {
        "destination" => "ac3540c7-5453-424d-bdfd-8ef2d9ff78df",
        "body" => "Feliz ano novo!",
        "target_url" => "https://app.passaporteweb.com.br",
        "scheduled_to" => "2012-01-01 00:00:00"
      }
      notification = PassaporteWeb::Notification.new(attributes)
      notification.should_not be_persisted
      notification.uuid.should be_nil
      notification.attributes.should == {}
      notification.destination.should == "ac3540c7-5453-424d-bdfd-8ef2d9ff78df"
      notification.body.should == "Feliz ano novo!"
      notification.target_url.should == "https://app.passaporteweb.com.br"
      notification.scheduled_to.should == "2012-01-01 00:00:00"
      notification.absolute_url.should be_nil
      notification.sender_data.should be_nil
      notification.read_at.should be_nil
      notification.notification_type.should be_nil
    end
  end

  describe ".find_all", :vcr => true do
    before(:each) do
      PassaporteWeb.configuration.user_token = "f01d30c0a2e878fecc838735560253f9e9395932f5337f40"
    end
    context "on success" do
      it "should return the first 20 notifications for the authenticated user, along with pagination information" do
        data = PassaporteWeb::Notification.find_all

        notifications = data.notifications
        notifications.size.should == 2
        notifications.map { |n| n.instance_of?(described_class) }.uniq.should be_true
        n1, n2 = notifications
        n1.body.should == '"oioioi"' # TODO why? was it created like this?
        n2.body.should == '"oioioisss"'
        n1.uuid.should == "2ca046be-0178-418d-80ac-3a334c264009"
        n2.uuid.should == "11f40530-2de0-471d-b1f7-ff39ea21363f"

        meta = data.meta
        meta.limit.should == 20
        meta.next_page.should == nil
        meta.prev_page.should == nil
        meta.first_page.should == 1
        meta.last_page.should == 1
      end
      it "should return notifications for the authenticated user according to params, along with pagination information" do
        data = PassaporteWeb::Notification.find_all(2, 1, nil, true, "newest-first")

        notifications = data.notifications
        notifications.size.should == 1
        notifications.map { |n| n.instance_of?(described_class) }.uniq.should be_true
        n1 = notifications.first
        n1.body.should == '"oioioi"' # TODO why? was it created like this?
        n1.uuid.should == "2ca046be-0178-418d-80ac-3a334c264009"

        meta = data.meta
        meta.limit.should == 1
        meta.next_page.should == nil
        meta.prev_page.should == 1
        meta.first_page.should == 1
        meta.last_page.should == 2
      end
    end
    context "on failure" do
      it "400 Bad Request" do
        PassaporteWeb::Notification.find_all(1, 20, nil, true, 'lalala').should == {"ordering"=>["Faça uma escolha válida. lalala não está disponível."]}
      end
      it "404 Not Found" do
        expect {
          PassaporteWeb::Notification.find_all(1_000_000)
        }.to raise_error(RestClient::ResourceNotFound, '404 Resource Not Found')
      end
    end
  end

  describe ".count", :vcr => true do
    before(:each) do
      PassaporteWeb.configuration.user_token = "f01d30c0a2e878fecc838735560253f9e9395932f5337f40"
    end
    context "on success" do
      it "should return count of notifications for the authenticated user" do
        PassaporteWeb::Notification.count.should == 2
      end
      it "should return count of notifications for the authenticated user, according to params" do
        PassaporteWeb::Notification.count(true, '2013-04-02').should == 2
      end
    end
    context "on failure" do
      it "it should return an error message if an invalid parameter is sent" do
        PassaporteWeb::Notification.count(false, "lalala").should == {"since"=>["Informe uma data/hora válida."]}
      end
    end
  end

end
