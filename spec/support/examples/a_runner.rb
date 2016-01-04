shared_examples 'a runner' do
  [:create_remote_file_ex, :scp_to_ex, :shell_ex, :resource, :execute_manifest].each do |name|
    it { is_expected.to respond_to(name) }
  end
end
