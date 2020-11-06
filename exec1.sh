if [ "$#" -ne 1 ]; then
    echo "Number of arguments not equal to 1. Exit."
    exit
fi

echo "Arg: $1"
binPath="$1"

if [ -x "$(command -v aplay)" ]; then
    aplay $binPath/NyanCat.wav &
fi

applyColor(){
    if [ $1 -lt 1000 ]; then
        xgamma -rgamma "0.$1"
    else
        xgamma -rgamma "$(( $1 / 1000 )).$(( $1 % 1000 ))"
    fi

    if [ $2 -lt 1000 ]; then
        xgamma -ggamma "0.$2"
    else
        xgamma -ggamma "$(( $2 / 1000 )).$(( $2 % 1000 ))"
    fi

    if [ $3 -lt 1000 ]; then
        xgamma -bgamma "0.$3"
    else
        xgamma -bgamma "$(( $3 / 1000 )).$(( $3 % 1000 ))"
    fi
}

step=200

delay=0.1

up=2000
down=100

red=1000
green=1000
blue=1000
i=0

while :
do
    i=$(( $i + 1 ))
    #dec red
    while [ $red -gt $down ]
    do
        red=$(( $red - $step ))
        if [ $red -lt $down ]; then
            red=$down
        fi

        applyColor $red $green $blue
        sleep $delay
    done

    #dec green
    while [ $green -gt $down ]
    do
        green=$(( $green - $step ))
        if [ $green -lt $down ]; then
            green=$down
        fi
        applyColor $red $green $blue
        sleep $delay 
    done


    #inc red
    while [ $red -lt $up ]
    do
        red=$(( $red + $step ))
        if [ $red -gt $up ]; then
            red=$up
        fi
        applyColor $red $green $blue
        sleep $delay 
    done

    #dec blue
    while [ $blue -gt $down ]
    do
        blue=$(( $blue - $step ))
        if [ $blue -lt $down ]; then
            blue=$down
        fi
        applyColor $red $green $blue
        sleep $delay
    done


    #inc green
    while [ $green -lt $up ]
    do
        green=$(( $green + $step ))
        if [ $green -gt $up ]; then
            green=$up
        fi
        applyColor $red $green $blue
        sleep $delay
    done

    #dec red
    while [ $red -gt $down ]
    do
        red=$(( $red - $step ))
        if [ $red -lt $down ]; then
            red=$down
        fi

        applyColor $red $green $blue
        sleep $delay
    done

    #inc blue
    while [ $blue -lt $up ]
    do
        blue=$(( $blue + $step ))
        if [ $blue -gt $up ]; then
            blue=$up
        fi
        applyColor $red $green $blue
        sleep $delay
    done

    echo "Stage $i completed"

done
