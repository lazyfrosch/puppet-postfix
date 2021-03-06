require 'spec_helper'

describe 'postfix::transport' do
  let (:title) { 'foo' }
  let (:facts) { {
    :augeasversion => '1.2.0',
    :osfamily      => 'Debian',
    :rubyversion   => '1.9.3',
    :path            => '/foo/bar',
  } }
  let :pre_condition do
    "class { 'augeas': }"
  end

  context 'when sending wrong type for destination' do
    let (:params) { {
      :destination => ['bar'],
    } }

    it 'should fail' do
      expect {
        is_expected.to contain_augeas('Postfix transport - foo')
      }.to raise_error(Puppet::Error, /\["bar"\] is not a string/)
    end
  end

  context 'when sending wrong type for nexthop' do
    let (:params) { {
      :destination => 'bar',
      :nexthop     => ['baz'],
    } }

    it 'should fail' do
      expect {
        is_expected.to contain_augeas('Postfix transport - foo')
      }.to raise_error(Puppet::Error, /\["baz"\] is not a string/)
    end
  end

  context 'when sending wrong type for file' do
    let (:params) { {
      :destination => 'bar',
      :file        => ['baz'],
    } }

    it 'should fail' do
      expect {
        is_expected.to contain_augeas('Postfix transport - foo')
      }.to raise_error(Puppet::Error, /\["baz"\] is not a string/)
    end
  end

  context 'when sending wrong value for file' do
    let (:params) { {
      :destination => 'bar',
      :file        => 'baz',
    } }

    it 'should fail' do
      expect {
        is_expected.to contain_augeas('Postfix transport - foo')
      }.to raise_error(Puppet::Error, /"baz" is not an absolute path/)
    end
  end

  context 'when sending wrong type for ensure' do
    let (:params) { {
      :destination => 'bar',
      :ensure      => ['baz'],
    } }

    it 'should fail' do
      expect {
        is_expected.to contain_augeas('Postfix transport - foo')
      }.to raise_error(Puppet::Error, /\["baz"\] is not a string/)
    end
  end

  context 'when sending wrong value for ensure' do
    let (:params) { {
      :destination => 'bar',
      :ensure      => 'running',
    } }

    it 'should fail' do
      expect {
        is_expected.to contain_augeas('Postfix transport - foo')
      }.to raise_error(Puppet::Error, /\$ensure must be either/)
    end
  end

  context 'when using default values' do
    it { is_expected.to contain_class('postfix::augeas') }
    it { is_expected.to contain_augeas('Postfix transport - foo').with(
      :incl    => '/etc/postfix/transport',
      :lens    => 'Postfix_Transport.lns',
      :changes => [
        "set pattern[. = 'foo'] 'foo'",
        "clear pattern[. = 'foo']/transport",
        "clear pattern[. = 'foo']/nexthop",
      ])
    }
  end

  context 'when overriding default values' do
    let (:params) { {
      :destination => 'bar',
      :nexthop     => 'baz',
      :file        => '/tmp/transport',
      :ensure      => 'present',
    } }

    it { is_expected.to contain_class('postfix::augeas') }
    it { is_expected.to contain_augeas('Postfix transport - foo').with(
      :incl    => '/tmp/transport',
      :lens    => 'Postfix_Transport.lns',
      :changes => [
        "set pattern[. = 'foo'] 'foo'",
        "set pattern[. = 'foo']/transport 'bar'",
        "set pattern[. = 'foo']/nexthop 'baz'",
      ])
    }
  end

  context 'when ensuring absence' do
    let (:params) { {
      :destination => 'bar',
      :ensure      => 'absent',
    } }

    it { is_expected.to contain_class('postfix::augeas') }
    it { is_expected.to contain_augeas('Postfix transport - foo').with(
      :incl    => '/etc/postfix/transport',
      :lens    => 'Postfix_Transport.lns',
      :changes => [
        "rm pattern[. = 'foo']",
      ])
    }
  end
end
