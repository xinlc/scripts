#!/bin/bash
#title           :r2t
#description     :This script will convert all rars(of jpg/bmp/png) with any content struct to tars(of jpg). Use "convert" command to convert images to jpg to depress disk space. the origin file's content struct will not change.
#author          :xdtianyu@gmail.com
#date            :20141029
#version         :1.0 final
#usage           :bash r2t
#bash_version    :4.3.11(1)-release
#==============================================================================

if [ $1 = "-c" ]; then 
	echo "cleaning..."
	cd tars
	for file in *.tar; do
	    RAR="${file%%.tar*}.rar"
	    echo "check \"$RAR\" ..."
	    if [ -f "../$RAR" ];then
		echo "delete $RAR ..."
		rm -i "../$RAR"
	    else
		echo "$RAR not exist."
	    fi
	done
	cd ..
	rm -ri tars
	exit 0
fi

check_sub(){
	echo "check sub."
    SAVEIFS=$IFS # setup this case the space char in file name.
    IFS=$(echo -en "\n\b")
	for subdir in $(find -maxdepth 1 -type d |grep ./ |cut -c 3-); 
        do 
            echo $subdir
            cd "$subdir"
            convert_to_jpg
            cd ..
    done
    IFS=$SAVEIFS
}

convert_to_jpg(){
    
    for ext in jpg JPG bmp BMP png PNG; do
        echo "ext is $ext"
        if [ ! $(find . -maxdepth 1 -name \*.$ext | wc -l) = 0 ]; 
	    then 
		    x2jpg $ext
	    fi
    done

    check_sub # check if has sub directory.
}

x2jpg(){
    if [ ! -d origin ];then
	mkdir origin
    fi
    if [ ! -d /tmp/jpg ]; then

	    mkdir /tmp/jpg
    fi

    tmp_fifofile="/tmp/$$.fifo"
    mkfifo $tmp_fifofile      # create a fifo type file.
    exec 6<>$tmp_fifofile      # point fd6 to fifo file.
    rm $tmp_fifofile


    thread=10 # define numbers of threads.
    for ((i=0;i<$thread;i++));do 
    echo
    done >&6 # actually only put $thread RETURNs to fd6.

    for file in ./*.$1;do
    read -u6 
    {
        echo 'convert -quality 80' "$file" /tmp/jpg/"${file%.*}"'.jpg'
        convert -limit memory 64 -limit map 128 -quality 80 "$file" /tmp/jpg/"${file%.*}".jpg
        mv "$file" origin
        echo >&6
    } &
    done

    wait # wait for all child thread end.
    exec 6>&- # close fd6

    mv /tmp/jpg/* .
    rm -r origin

    echo 'DONE!'
}


for file in *.rar ; do
	tmpdir=$(mktemp -d)
	DIR="${file%%.rar*}"
	echo "unrar x $file $tmpdir";
	mv "$file" tmp.rar
	unrar x tmp.rar $tmpdir # unrar to a tmp directory.
	mv tmp.rar "$file"

	if [ $(ls $tmpdir | wc -l) = 1 ]; then # check if has folders, and mv the unrared directory as same name with the rar file.
		DIR2=$(ls $tmpdir)
		mv "$tmpdir/$DIR2" "$DIR"
		rmdir $tmpdir
	else
		mv $tmpdir "$DIR"
	fi	

	echo $DIR
	if [ -d "$DIR" ];
	then
		cd "$DIR"
		convert_to_jpg # convert process.
        cd ..
        echo "tar cvf $DIR.tar $DIR" 
        tar cvf "$DIR.tar" "$DIR" # tar the directory.
		rm -r "$DIR"
	else
		echo "$DIR not exist."
	fi
done

if [ ! -d "tars" ]; then
    mkdir tars
fi

if [ ! $(find . -maxdepth 1 -name \*.tar | wc -l) = 0 ]; 
then 
	mv *.tar tars
fi

# check status.
for file in *.rar; do
    TAR="tars/${file%%.rar*}.tar"
    echo "check \"$TAR\" ..."
    if [ -f "$TAR" ];then
        echo "$file convert OK."
        cd tars
        md5sum "${file%%.rar*}.tar" > "${file%%.rar*}.md5" # generate md5 file.
        cd ..
    else
        echo "$file convert FAILED."
    fi
done
