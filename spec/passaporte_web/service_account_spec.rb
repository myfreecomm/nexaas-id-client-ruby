# encoding: utf-8
require 'spec_helper'

describe PassaporteWeb::ServiceAccount do

  describe ".new" do
    it "should instanciate an empty object" do
      service_account = PassaporteWeb::ServiceAccount.new
      service_account.attributes.should == {:plan_slug=>nil, :expiration=>nil, :identity=>nil, :roles=>nil, :member_uuid=>nil, :role=>nil, :include_expired_accounts=>nil, :name=>nil, :members_data=>nil, :url=>nil, :service_data=>nil, :account_data=>nil, :add_member_url=>nil}
    end
    it "should instanciate an object with attributes set" do
      attributes = {
        "plan_slug"=>"free",
        "expiration"=>"2011-12-31",
        "identity"=>"ac3540c7-5453-424d-bdfd-8ef2d9ff78df",
        "roles"=>"admin,user",
        "member_uuid"=>"ac3540c7-5453-424d-bdfd-8ef2d9ff78df",
        "role"=>"owner",
        "include_expired_accounts"=>"true",
        "name"=>"Conta Pessoa",
        "members_data" => nil,
        "url" => nil,
        "service_data" => nil,
        "account_data" => nil,
        "add_member_url" => nil
      }
      service_account = PassaporteWeb::ServiceAccount.new(attributes)
      service_account.attributes.should == { :plan_slug=>"free", :expiration=>"2011-12-31", :identity=>"ac3540c7-5453-424d-bdfd-8ef2d9ff78df", :roles=>"admin,user", :member_uuid=>"ac3540c7-5453-424d-bdfd-8ef2d9ff78df", :role=>"owner", :include_expired_accounts=>"true", :name=>"Conta Pessoa", :members_data=>nil, :url=>nil, :service_data=>nil, :account_data=>nil, :add_member_url=>nil }
      service_account.plan_slug.should == "free"
      service_account.expiration.should == "2011-12-31"
      service_account.identity.should == "ac3540c7-5453-424d-bdfd-8ef2d9ff78df"
      service_account.roles.should == "admin,user"
      service_account.member_uuid.should == "ac3540c7-5453-424d-bdfd-8ef2d9ff78df"
      service_account.role.should == "owner"
      service_account.include_expired_accounts.should == "true"
      service_account.name.should == "Conta Pessoa"
    end
  end

  describe ".find_all", :vcr => true do
    let(:mock_response) { double('response', body: MultiJson.encode([]), code: 200, headers: {link: "<http://sandbox.app.passaporteweb.com.br/organizations/api/accounts/?page=3&limit=3>; rel=next, <http://sandbox.app.passaporteweb.com.br/organizations/api/accounts/?page=1&limit=3>; rel=prev"}) }
    it "should find all accounts related to the authenticated application and return them as an array of Account instances" do
      accounts_and_meta = PassaporteWeb::ServiceAccount.find_all

      service_accounts = accounts_and_meta.service_accounts
      service_accounts.should be_instance_of(Array)
      service_accounts.size.should == 15
      service_accounts.map { |a| a.instance_of?(PassaporteWeb::ServiceAccount) }.uniq.should == [true]
      service_accounts.map(&:plan_slug).uniq.sort.should == ['free', 'passaporteweb-client-ruby']
      service_accounts.map(&:persisted?).uniq.sort.should == [true]

      meta = accounts_and_meta.meta
      meta.limit.should == 20
      meta.next_page.should == nil
      meta.prev_page.should == nil
      meta.first_page.should == 1
      meta.last_page.should == 1
    end
    it "should return information about all possible pages" do
      accounts_and_meta = PassaporteWeb::ServiceAccount.find_all(3, 3)

      service_accounts = accounts_and_meta.service_accounts
      service_accounts.should be_instance_of(Array)
      service_accounts.size.should == 3

      meta = accounts_and_meta.meta
      meta.limit.should == 3
      meta.next_page.should == 4
      meta.prev_page.should == 2
      meta.first_page.should == 1
      meta.last_page.should == 5
    end
    it "should ask for page 1 and 20 accounts per page by default" do
      PassaporteWeb::Http.should_receive(:get).with("/organizations/api/accounts/?page=1&limit=20").and_return(mock_response)
      PassaporteWeb::ServiceAccount.find_all
    end
    it "should ask for page and accounts per page as supplied" do
      PassaporteWeb::Http.should_receive(:get).with("/organizations/api/accounts/?page=4&limit=100").and_return(mock_response)
      PassaporteWeb::ServiceAccount.find_all(4, 100)
    end
    it "should raise an error if the page does not exist" do
      expect {
        PassaporteWeb::ServiceAccount.find_all(4_000_000)
      }.to raise_error(RestClient::ResourceNotFound, '404 Resource Not Found')
    end
  end

  describe ".find", :vcr => true do
    context "on success" do
      it "should return an instance of Account with all the details" do
        service_account = PassaporteWeb::ServiceAccount.find("859d3542-84d6-4909-b1bd-4f43c1312065")
        service_account.should be_instance_of(PassaporteWeb::ServiceAccount)
        service_account.plan_slug.should == "free"
        service_account.should be_persisted
        service_account.account_data.should == {"name" => "Investimentos", "uuid" => "859d3542-84d6-4909-b1bd-4f43c1312065"}
        service_account.service_data.should == {"name" => "Identity Client", "slug" => "identity_client"}
        service_account.members_data.should == [
          {"membership_details_url"=>"/organizations/api/accounts/859d3542-84d6-4909-b1bd-4f43c1312065/members/20a8bbe1-3b4a-4e46-a69a-a7c524bd2ab8/", "identity"=>"20a8bbe1-3b4a-4e46-a69a-a7c524bd2ab8", "roles"=>["owner"]},
          {"membership_details_url"=>"/organizations/api/accounts/859d3542-84d6-4909-b1bd-4f43c1312065/members/5e32f927-c4ab-404e-a91c-b2abc05afb56/", "identity"=>"5e32f927-c4ab-404e-a91c-b2abc05afb56", "roles"=>["user"]}
        ]
        service_account.expiration.should be_nil
        service_account.url.should == "/organizations/api/accounts/859d3542-84d6-4909-b1bd-4f43c1312065/"
        service_account.add_member_url.should == "/organizations/api/accounts/859d3542-84d6-4909-b1bd-4f43c1312065/members/"
      end
    end
    context "on failure" do
      it "should raise an error if no Account exist with that uuid" do
        expect {
          PassaporteWeb::ServiceAccount.find("859d3542-84d6-4909-b1bd-4f43c1312062")
        }.to raise_error(RestClient::ResourceNotFound, '404 Resource Not Found')
      end
    end
  end

  describe "#uuid", :vcr => true do
    let(:service_account) { PassaporteWeb::ServiceAccount.find("859d3542-84d6-4909-b1bd-4f43c1312065") }
    it "should return the uuid of the ServiceAccount" do
      service_account = PassaporteWeb::ServiceAccount.find("859d3542-84d6-4909-b1bd-4f43c1312065")
      service_account.account_data.should == {"name" => "Investimentos", "uuid" => "859d3542-84d6-4909-b1bd-4f43c1312065"}
      service_account.uuid.should == '859d3542-84d6-4909-b1bd-4f43c1312065'
    end
    it "should return nil if the ServiceAccount has no uuid yet" do
      service_account = PassaporteWeb::ServiceAccount.new
      service_account.account_data.should be_nil
      service_account.uuid.should be_nil
    end
  end

  describe "#save", :vcr => true do
    let(:service_account) { PassaporteWeb::ServiceAccount.find("859d3542-84d6-4909-b1bd-4f43c1312065") }
    context "on success" do
      it "should update the ServiceAccount attributes on the server" do
        service_account.plan_slug.should == 'free'
        service_account.expiration.should == '2014-04-01 00:00:00'

        service_account.plan_slug = 'basic'
        service_account.expiration = '2014-05-01'

        service_account.should be_persisted
        expect(service_account.save).to be_truthy
        service_account.should be_persisted

        service_account.plan_slug.should == 'basic'
        service_account.expiration.should == '2014-05-01 00:00:00'

        service_account = PassaporteWeb::ServiceAccount.find("859d3542-84d6-4909-b1bd-4f43c1312065")
        service_account.plan_slug.should == 'basic'
        service_account.expiration.should == '2014-05-01 00:00:00'
      end
    end
    context "on failure" do
      it "should return false and set the errors hash" do
        service_account.plan_slug = nil # required
        service_account.expiration = nil
        service_account.should be_persisted
        expect(service_account.save).to be_falsy
        service_account.should be_persisted
        service_account.errors.should == {"field_errors"=>{"plan_slug"=>["Este campo é obrigatório."]}}
      end
    end
  end

  describe '#activate', vcr: true do
    let(:service_account) { PassaporteWeb::ServiceAccount.find("019a3450-8107-4832-8321-de4e6580c06b") }
    let(:responsible_identity) { "20a8bbe1-3b4a-4e46-a69a-a7c524bd2ab8" }

    context "on success" do
      it "activates the service account an returns true" do
        expect(service_account.activate(responsible_identity)).to be_truthy
      end

      it "assigns no errors" do
        service_account.activate(responsible_identity)
        expect(service_account.errors).to eq({})
      end
    end

    context "on failure" do
      context "when given wrong identity" do
        let(:service_account) { PassaporteWeb::ServiceAccount.find("bc4bb967-e5b2-4925-813c-4d1e5418247a") }
        let(:responsible_identity) { 'wrong-idendity' }

        it "returns false" do
          expect(service_account.activate(responsible_identity)).to be_falsy
        end

        it "assigns errors" do
          service_account.activate(responsible_identity)
          expect(service_account.errors).to eq({"field_errors" => {"identity"=>["Informe um valor v\u00E1lido."]}})
        end
      end
    end
  end

end
