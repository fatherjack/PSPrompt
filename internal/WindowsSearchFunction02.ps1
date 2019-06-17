# from https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/searching-files-using-index-search

function Search-FileContent ([String][Parameter(Mandatory)]$FilterText, $Path = $home ) { 
    $objConnection = New-Object -COM ADODB.Connection 
    $objRecordset = New-Object -COM ADODB.Recordset 
 
    $objConnection.Open("Provider=Search.CollatorDSO;Extended properties='Application=Windows';")  
 
    $objRecordset.Open("SELECT System.ItemPathDisplay FROM SYSTEMINDEX WHERE Contains('""$FilterText""') AND SCOPE='$Path'", $objConnection) 
    $t = 1
    While ($t -eq 1 ) { 
        $objRecordset.Fields.Item("System.ItemPathDisplay").Value 
        $null = $objRecordset.MoveNext()
        $t = 2
    }     
    # While (!$objRecordset.EOF ) { 
    #     $objRecordset.Fields.Item("System.ItemPathDisplay").Value 
    #     $null = $objRecordset.MoveNext() 
    # }     
}

Search-FileContent dublin

# from https://www.petri.com/how-to-query-the-windows-search-index-using-sql-and-powershell
$sql = "SELECT System.ItemName, System.DateCreated FROM SYSTEMINDEX WHERE System.ContentStatus = 'Complete' AND SCOPE = 'c:\users\russell\skydrive\documents\petri\'"
$provider = "provider=search.collatordso;extended properties=’application=windows’;" 
$connector = new-object system.data.oledb.oledbdataadapter -argument $sql, $provider 
$dataset = new-object system.data.dataset 
if ($connector.fill($dataset)) { $dataset.tables[0] }

