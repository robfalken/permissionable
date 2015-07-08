require 'permissionable'
require 'dummy'


class FlakyDummy
  include Permissionable
end


describe Permissionable do
  context 'permission definitions' do
    subject(:permissions) { Dummy.instance_variable_get(:@permissions) }

    context 'valid' do
      it { is_expected.to have_key(:run) }
      it { is_expected.to have_key(:walk) }
      it { is_expected.to have_key(:sit) }
      it { is_expected.to have_key(:play) }
      it { is_expected.to have_key(:eat) }

      it 'creates a geometric sequence' do
        expect(permissions[:run]).to eq(1)
        expect(permissions[:walk]).to eq(2)
        expect(permissions[:sit]).to eq(4)
        expect(permissions[:play]).to eq(8)
        expect(permissions[:eat]).to eq(16)
      end
    end

    context 'invalid' do
      it 'can not assign 0' do
        expect{
          FlakyDummy.permissions(nope: 0)
        }.to raise_exception
      end

      it 'can only assign integers' do
        expect{
          FlakyDummy.permissions(nope: '1')
        }.to raise_exception
      end
    end
  end

  context 'instance' do
    it 'has permissions getter' do
      dummy = Dummy.new
      expect(dummy).to respond_to(:permissions)
      expect(dummy.permissions).to be_an_instance_of(Permissionable::Permissions)
    end

  end

end
