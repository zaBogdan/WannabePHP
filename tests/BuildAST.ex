__global__

Int $x -> 20;
Int $vec[] -> (12, 42, 2, 23);

__custom_types__

Int Hello(Int $z)
{
    $z -> 20;
}

__main__

$x -> [ 10 + 20 + 20 ];
$x -> [[ $x < 30 ]];

$x -> [ (10 + $vec[3]) * 15 + 12.7 + Hello(12) ];

String $data -> "We are testing funcs";
Print("Value is", $x);

Int $y -> [ $x - Max(20, 30) + Min($x, $vec[0]) * Len($data) ];


Int $z1 -> [ $vec[0] + 10 * 9 ];

Print("Z: ", $z1) ;

Print("Max of", Max(12, 42));
Print("Calculating y: ", Hello(10));
Print("Getting a random val at each run: ", RandomInt());