# inspec-datadog

This is a custom InSpec resource for DataDog.

For more information, please refer to https://docs.chef.io/inspec/dsl_resource/.

## Usage

```ruby
control 'datadog' do
  title 'this is a datadog test'
  describe datadog_monitor(name: 'my_monitor_name') do
    it { should exist }
    its('type') { should eq 'service check' }
  end
end
```

## License

Copyright 2021 HG Insights, Inc.
