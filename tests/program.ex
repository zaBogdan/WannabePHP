__global__

//toate tipurile variabilele definite
Int $x -> 10;
Float $y -> 1.24;
Char $mert -> 'M';
String $mere -> "Ana are mere";
Boolean $bestCompiler -> true;


//variabile constante
Readonly Int $data -> 1204;

//varibile declarate
Int $xx;

//variabile de tip array
Int[] $arrayInt -> (12,24,45,56,57,78);


__custom_types__

//declarari de functii
Int FunctiaMeaFantoma[Int Data]
{
    daca[Data === 10]
    {
        return 1;
    }
    return 0;
}

//declarari de clase pentru OOP
Object AdiMinune
{
    public Int $x -> 10;
    private Boolean compilareaMeaFantoma[]
    {
        return false;
    }

    public Boolean[] $bitMap -> (true,true,true,false,true,false);
};

__main__

Print("Am inceput programul nostru minunat");
AdiMinune $singer;
Print(singer.$x);

//instructiunea while
catTimp(singer.$x !== 0)
{
    $singer.$x -> $singer.$x - 1;
    $singer.$x -> $singer.$x * 10 + $x ^ $arrayInt(3);
}

Int $idx;
//instructiunea for
pentru[$idx->0; $idx <= 10; $idx = $idx + 1]
{
    daca[$idx % 2 === 0]
    {
        Print(FunctiaMeaFantoma($idx));
    }altfel
    {
        Print("Numar Impar");
    }
}