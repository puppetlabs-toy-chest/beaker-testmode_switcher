shared_examples 'a runner' do
  %i[create_remote_file_ex scp_to_ex shell_ex resource execute_manifest execute_manifest_on].each do |name|
    it { is_expected.to respond_to(name) }
  end
end
