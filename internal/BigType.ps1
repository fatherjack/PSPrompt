$Set = @{
    A = ( '   AA    ','  AAAA  ',' AA  AA ','AAAAAAAA','AA    AA')
    B = 
('BBBBBB','BB    BB','BB    BB','BBBBBB','BB    BB','BB    BB','BBBBBB')
    C = ('  CCCCC  ','CC     CC','CC','CC','CC     CC','  CCCCC')
D=@"
"@
E=@"
"@
F=@"
"@
G=@"
"@
H=@"
"@
I=@"
"@
J = @"
"@
K = @"
"@
M = @"
"@
N = @"
"@
O = @"
"@
P = @"
"@
Q = @"
"@
R = @"
"@
S = @"
"@
T = @"
"@
U = @"
"@
V = @"
"@
W = @"
"@
X = @"
"@
Y = @"
"@
Z = @"
"@
}
Write-output $Set.A

$str = -join ($Set.A, [char]10, $Set.B, [char]10, $Set.c)

$str

$str = ($Set.A, $Set.B, $Set.c) -join (" ")

$str

0..10 | ForEach-Object {
    ($Set.A[$_], $Set.B[$_]) -join (" ")
}