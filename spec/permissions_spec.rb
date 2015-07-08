require 'pry'
require 'permissionable'
require 'dummy'

describe Permissionable::Permissions do
  before(:each) { @permissions = Permissionable::Permissions.new(Dummy.new) }

  it 'implements #to_i' do
    expect(@permissions.to_i).to eq(0)
  end

  it 'can add permission with <<' do
    expect{
      @permissions << :play
    }.to change{@permissions.to_i}.by(8)
  end

  it 'can add permission with #add' do
    expect{
      @permissions << :walk
    }.to change{@permissions.to_i}.by(2)
  end

  it 'can remove permission with #remove' do
    @permissions << :play
    expect{
      @permissions.remove(:play)
    }.to change{@permissions.to_i}.by(-8)
  end

  it 'is true with one included permission' do
    @permissions << :run
    expect(@permissions.include?(:run)).to be true
  end

  it 'is false with one missing permission' do
    @permissions << :run
    expect(@permissions.include?(:walk)).to be false
  end

  it 'is true for multiple existing permissions' do
    @permissions << :run
    @permissions << :walk

    expect(@permissions.include?(:run, :walk)).to be true
  end

  it 'it is false when one of asserted is missing' do
    @permissions << :run
    @permissions << :walk
    expect(@permissions.include?(:run, :play)).to be false
  end

  it 'can check with []' do
    @permissions << :run
    @permissions << :sit
    expect(@permissions[:run]).to eq(true)
    expect(@permissions[:sit, :run]).to eq(true)
    expect(@permissions[:play]).to eq(false)
  end

  it 'updates column when adding permission' do
    @owner = Dummy.new
    @permissions = Permissionable::Permissions.new(@owner)
    expect(@owner).to receive(:update_column).with(:permission, 2)
    @permissions << :walk
  end

  it 'updates column when removing permission' do
    @owner = Dummy.new
    @permissions = Permissionable::Permissions.new(@owner)
    @permissions << :run
    expect(@owner).to receive(:update_column).with(:permission, 0)
    @permissions.remove :run
  end
end
