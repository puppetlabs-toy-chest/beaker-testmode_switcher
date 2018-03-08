methods = %i[create_remote_file_ex scp_to_ex shell_ex resource execute_manifest execute_manifest_on]

shared_examples 'a runner' do
  methods.each do |name|
    it { is_expected.to respond_to(name) }
  end
end

shared_examples 'a fully implemented runner' do
  methods.each do |name|
    it "should implement #{name} instead of mixing in Beaker::TestmodeSwitcher::DSL" do
      method = subject.class.instance_method(name)
      expect(method.owner).to_not be(Beaker::TestmodeSwitcher::DSL)
    end
  end
end
