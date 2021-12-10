require 'datadog_api_client'

# InSpec for DataDog API Synthetics
class DataDogSyntheticAPI < Inspec.resource(1)
  name 'datadog_synthetic_api'
  desc 'A DataDog API Synthetic'
  example "
    # if api_key and application_key are absent, the DD_API_KEY and DD_APP_KEY env vars will automatically be used
    describe datadog_synthetic_api(name: 'mysynthetic', api_key: '12345', application_key: '67890') do
      it { should exist }
      its('subtype') { should eq 'http' }
    end
  "

  def initialize(opts = {})
    @opts = opts
    begin
      if @opts[:api_key] && @opts[:application_key]
        DatadogAPIClient::V1.configure do |config|
          config.api_key = @opts[:api_key]
          config.application_key = @opts[:application_key]
        end
      end
      api_instance = DatadogAPIClient::V1::SyntheticsAPI.new
      synthetics = api_instance.list_tests.tests
      fail_resource("cannot find api synthetic #{@opts[:name]}") if synthetics.nil? || synthetics.size.zero?
      @synthetic = synthetics.select { |test| test.name == @opts[:name] }.first
    rescue StandardError => e
      fail_resource("error getting synthetic #{@opts[:name]}: #{e}")
    end
  end

  def name
    @synthetic.name
  end

  def creator
    @synthetic.creator
  end

  def id
    @synthetic.public_id
  end

  def priority
    @synthetic.options.monitor_priority
  end

  def message
    @synthetic.message
  end

  def type
    @synthetic.type
  end

  def subtype
    @synthetic.subtype
  end

  def request
    @synthetic.config.request
  end

  def assertion
    @synthetic.config.assertions[0]
  end

  def renotify_interval
    @synthetic.options.monitor_options.renotify_interval
  end

  def retry
    @synthetic.options._retry
  end

  def tick_every
    @synthetic.options.tick_every
  end

  def locations
    @synthetic.locations
  end

  def status
    @synthetic.status
  end

  def tags
    @synthetic.tags
  end

  def exists?
    true
  end

  def to_s
    "DataDog synthetic #{@opts[:name]}"
  end
end
