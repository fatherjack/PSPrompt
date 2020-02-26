Describe 'Internal function files' {
	context 'Existence'	{
	$Files = get-childitem ..\functions
	
		it 'Nth Command should exist' {
			$Files | should contain 'Nth-command.ps1'
		}
		it 'Prompt should exist' {
			$Files | should contain 'Prompt.ps1'
		}
		it 'Write PSPLog should exist' {
			$Files | should contain 'WritePSPLog.ps1'
		}
	}
}
