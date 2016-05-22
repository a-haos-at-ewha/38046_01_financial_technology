# this script sets up a vm to run ... (need to put the right word here!)

# ToDo : This is garbage, make it better. (5_12_16)

# ToDo : Move to Cloud9 VM project directory.


function make_directory_if_not_already_present() {
    cd "$GOPATH"
    echo ""
    if [ -z "$1" ]
    then
        echo "no arg passed."
    else
        if [ -d "$1" ]
        then
            # echo "Directory $1 does exist."
            return 0;
        else
            echo "Directory $1 does not exist."
            echo "Creating $1 directory."
            mkdir "$1"
            return 1;
        fi
    fi
    #echo ""
}

function setup_numpy() {
    # Let's make numpy work!
    
    sudo apt-get update
    sudo apt-get -y install python-numpy
}

function setup_temporary_fintech_workspace() {
    if [ -z "$1" ]
    then
        echo "no arg passed."
    else
        if make_directory_if_not_already_present "$1"
        then
        echo "There is already a $1 directory. I don't know what to do!"
        else
        echo "created $1 directory."
        cd "$1"
        
:<<EOF
EOF
        # Get the files from GitHub repo : https://github.com/mnielsen/neural-networks-and-deep-learning
        wget https://github.com/mnielsen/neural-networks-and-deep-learning/archive/master.zip
        # Unzip the files.
        unzip master.zip -d ./temp
        local deep_learning_scripts_directory="finech_task_dependencies"
        local fintech_task_runners="fintech_task_runners"
        local data_source_directory="fintech_test_data"
        local data_deposit_directory="data_runners_created"
        # Make a directory for the tasks
        mkdir "$deep_learning_scripts_directory"
        mkdir "$fintech_task_runners"
        mkdir "$data_source_directory"
        
        cp -rf ./temp/neural-networks-and-deep-learning-master/src/* "$deep_learning_scripts_directory/"
        cp -rf ./temp/neural-networks-and-deep-learning-master/data/* "$data_source_directory"
        
        
        setup_numpy
        cd "$fintech_task_runners"
        mkdir "$data_deposit_directory"
        create_base_python_script "$data_deposit_directory"
        fi

    fi
}

function create_base_python_script() {
cat > fintec_test_script.py <<EOL
import mnist_loader
training_data, validation_data, test_data = mnist_loader.load_data_wrapper()

import network

net = network.Network([784, 30, 10])

net.SGD(training_data, 30, 10, 3.0, test_data=test_data)

EOL
    
}

setup_temporary_fintech_workspace "haos_work"


:<<EOF

# Next we copy the files we need.

# This is the base of the command : cp -rf /source/path/ /destination/path/
# (the -rf is a switch with two options; recursive and force. It is very important that you be carefull with the use of the force switch!)

cp -rf neural-networks-and-deep-learning-master/src/* run_mnist_thingy/
cp -rf neural-networks-and-deep-learning-master/data/* data/


cd run_mnist_thingy
cat > do_some_figuring.py <<EOL
import mnist_loader
training_data, validation_data, test_data = mnist_loader.load_data_wrapper()

import network

net = network.Network([784, 30, 10])

net.SGD(training_data, 30, 10, 3.0, test_data=test_data)

EOL

python do_some_figuring.py

EOF