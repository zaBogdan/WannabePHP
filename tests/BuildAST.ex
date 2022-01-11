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

String $data -> "We are testing funcs";
Print("Value is", $x);

Int $y -> $x - Max(20, 30) + Min($x, $vec[0]) * Len($data);

Print("Calculating y: ", $y);
Print("Getting a random val at each run: ", RandomInt());