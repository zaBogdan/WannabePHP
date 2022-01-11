__global__

Int $x -> 20;
Int $vec[] -> (12, 42, 2, 23);

__custom_types__

Int Hello(Int $z)
{
    $z -> 20;
}

__main__

$x -> (10 + $vec[3]) * 15 + 12.7 + Hello(12);

Print("Value is", $x);