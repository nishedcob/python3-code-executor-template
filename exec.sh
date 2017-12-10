#! /bin/sh

DEBUG=true
NULL="/dev/null"
PRINT_NULL="> $NULL 2> $NULL"

if $DEBUG; then
	echo ""

	whoami
	echo "says hello world!"
	echo "from Docker!"

	echo ""

	lsb_release -a
	uname -a

	echo ""

	cat /etc/os-release

	echo ""
fi

os_id=$(grep "^\(ID\|id\)=" /etc/os-release | awk -F= '{print $2}')

if $DEBUG; then
	echo "Detected OS ID: $os_id"
fi

env_dir=env-$os_id

if $DEBUG; then
	echo "System Python 3:"
	python3 --version
fi

if [ -d $env_dir ] ; then
    rm_env="rm -rdv $env_dir"
    if [ -d $env_dir/bin ]; then
        if [ -f $env_dir/bin/python3 ]; then
		    if $DEBUG; then
                echo "VirtualEnv Python 3:"
                $env_dir/bin/python3 --version
		    fi
        else
		    if $DEBUG; then
                echo "No VirtualEnv Python"
                eval $rm_env
            else
                eval "$rm_env $PRINT_NULL"
		    fi
        fi
    else
		if $DEBUG; then
            echo "No VirtualEnv Bin"
            eval $rm_env
        else
            eval "$rm_env $PRINT_NULL"
		fi
    fi
else
    if $DEBUG; then
        echo "No VirtualEnv"
    fi
fi

if $DEBUG; then
    echo ""

    echo "=========================="
    echo "| VirtualEnv Management: |"
    echo "=========================="
fi

if [ ! -d $env_dir ]; then
    if $DEBUG; then
        echo "Creating VirtualEnv..."
        echo "----------------------"
    fi

	create_virtualenv="virtualenv --python=python3 $env_dir"
    if $DEBUG; then
        eval $create_virtualenv
    else
        eval "$create_virtualenv $PRINT_NULL"
    fi

    if $DEBUG; then
        echo "-----------------------------------"
    fi
fi

if $DEBUG; then
    echo "Installing Dependencies with Pip..."
    echo "-----------------------------------"
fi

pip_install="$env_dir/bin/pip3 install -r requirements.txt"
if $DEBUG; then
    eval $pip_install
else
    eval "$pip_install $PRINT_NULL"
fi

if $DEBUG; then
    echo ""

    echo "====================="
    echo "| Executing Python: |"
    echo "====================="
fi

$env_dir/bin/python3 main.py

