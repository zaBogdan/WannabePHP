__global__

Int $x -> 10;
Float $y -> 1.24;
Char $mert -> 'M';
String $mere -> "Ana are mere";
Boolean $bestCompiler -> True;

Readonly Int $data -> 1204;
Readonly Float $flotant -> 1204.352;
Readonly String $hatzJohn -> "haaatzzz johnutzule";
Readonly Boolean $done -> False;

Int $xx;

__custom_types__


Int PutereMotor[Int $hello, Int $world]
{
    Int $xxx -> 10;
}


Object Mercedes
{
    public Int $xxxx;
    private Float $data2 -> 14.3252;

    Int Hello[Int $world4, Int $data5]
    {
        Int $jajaja -> 10;
        $mere -> "ana are mere";
        $world4 -> 10;
    }

    Int PutereMotor[Int $helloWorld, Int $world2]
    {
        Int $xulescu -> 10;
    }
};

__main__
Int $yred;
Int $z;
Int $w;

$yred -> 1024;
Print["hello",10];
Print["world",10.324];
Print["value is",$yred];
$yred -> 1337;
Print["value is",$yred];


Mercedes.PutereMotor[PutereMotor[$data, $z], 20];
