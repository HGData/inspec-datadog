require 'datadog_api_client'

# InSpec for DataDog Monitors
class DataDogMonitor < Inspec.resource(1)
  name 'datadog_monitor'
  desc 'A DataDog Monitor'
  example "
    # if api_key and application_key are absent, the DD_API_KEY and DD_APP_KEY env vars will automatically be used
    describe datadog_monitor(name: 'mymonitor', api_key: '12345', application_key: '67890') do
      it { should exist }
      its('type') { should eq 'service check' }
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
      api_instance = DatadogAPIClient::V1::MonitorsAPI.new
      monitors = api_instance.list_monitors({ name: @opts[:name] })
      fail_resource("cannot find monitor #{@opts[:name]}") if monitors.nil? || monitors.size.zero?
      @monitor = monitors.first
    rescue StandardError => e
      fail_resource("error getting monitor #{@opts[:name]}: #{e}")
    end
  end

  def creator
    @monitor.creator
  end

  def id
    @monitor.id
  end

  def message
    @monitor.message
  end

  def multi
    @monitor.multi
  end

  def name
    @monitor.name
  end

  def options
    @monitor.options
  end

  def overall_state
    @monitor.options
  end

  def priority
    @monitor.priority
  end

  def query
    @monitor.query
  end

  def restricted_roles
    @monitor.restricted_roles
  end

  def state
    @monitor.state
  end

  def tags
    @monitor.tags
  end

  def type
    @monitor.type
  end

  def exists?
    true
  end

  def to_s
    "DataDog monitor #{@opts[:name]}"
  end
end

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
      synthetics = api_instance.list_tests({ name: @opts[:name] })
      fail_resource("cannot find api synthetic #{@opts[:name]}") if synthetics.nil? || synthetics.size.zero?
      @synthetic = synthetics.first
    rescue StandardError => e
      fail_resource("error getting synthetic #{@opts[:name]}: #{e}")
    end
  end

  def monitor_id
    @synthetic.monitor_id
  end

  def message
    @synthetic.message
  end

  def name
    @synthetic.name
  end

  def options
    @synthetic.options
  end

  def config
    @synthetic.config
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

  def type
    @synthetic.type
  end

  def subtype
    @synthetic.subtype
  end

  def to_s
    "DataDog synthetic #{@opts[:name]}"
  end
end
