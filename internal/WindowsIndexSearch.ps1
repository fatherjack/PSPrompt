# from https://www.petri.com/how-to-query-the-windows-search-index-using-sql-and-powershell
1
$sql = @"
SELECT 
    System.ItemName, 
    System.Author, 
    System.DateCreated, 
    System.Comment 
FROM SYSTEMINDEX 
WHERE System.Comment IS NOT NULL 
AND System.DateCreated >= '2014-09-1' 
AND System.DateCreated < '2014-10-31' 
AND SCOPE = 'c:\users\russell\skydrive\documents\petri\'
"@

$sql = 
@"
SELECT System.ItemName, System.DateCreated 
FROM SYSTEMINDEX 
WHERE System.ContentStatus = 'Complete' 
    AND SCOPE = '$home\documents'
"@

$sql
$provider = "provider=search.collatordso; extended properties=’application=windows’; " 
$connector = new-object system.data.oledb.oledbdataadapter -argument $sql, $provider 
$dataset = new-object system.data.dataset 
if ($connector.fill($dataset)) { 
    $dataset.tables[0] | select-object system.itemname, system.author, system.datecreated, system
}