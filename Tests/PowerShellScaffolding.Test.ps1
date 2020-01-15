TestData = @{
	
}

$BufferSize = 4
$DataTypeName = [System.Byte[]]::new($BufferSize)
$RandomSeed = [System.Random]::new()
$RandomSeed.NextBytes($DataTypeName)

$TestData =	@(
	@{
		"TestValue" = "Value One"
		"TestType" = "String"
	},
	@{
		"TestValue" = 2
		"TestType" = "int32"
	},
	@{
		"TestValue" = $DataTypeName
		"TestType" = "Byte[]"
	}
) 




Describe "test some values" {
	It "Test if <TestValue> is a <TestType> Object"	-TestCase $TestData {
		param($TestValue, $TestType)
		get-DataTypeName -value $TestValue | Should -Be $TestType
	}
}
