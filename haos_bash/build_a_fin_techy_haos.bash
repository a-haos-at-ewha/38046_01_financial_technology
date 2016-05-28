# this script sets up a vm to run ... (need to put the right word here!)

# ToDo : This is garbage, make it better. (5_12_16)

# ToDo : Move to Cloud9 VM project directory.

fintec_workspace_directory = "fintechaos_workspace"

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


function get_update_and_do_upgrade() {
    sudo apt-get update
    sudo apt-get -y upgrade
}
function setup_numpy() {
    # Let's make numpy work!
    sudo apt-get -y install python-numpy
}

function setup_matplotlib() {
    # Let's make matplotlib work!
    sudo apt-get install -y udev
    sudo apt-get install -y initramfs-tools
    sudo apt-get install -y python-matplotlib
}

function create_fintech_workspace() {

    local deep_learning_scripts_directory="finech_task_dependencies"
    local fintech_task_runners="fintech_task_runners"
    local data_source_directory="fintech_test_data"
    local data_deposit_directory="data_runners_created"

    setup_numpy
    setup_matplotlib

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
        
            # Get the files from GitHub repo : https://github.com/mnielsen/neural-networks-and-deep-learning
            wget https://github.com/mnielsen/neural-networks-and-deep-learning/archive/master.zip
            # Unzip the files.
            unzip master.zip -d ./temp
            # Make a directory for the tasks
            mkdir "$deep_learning_scripts_directory"
            git clone https://github.com/a-haos-at-ewha/fintech_scripts.git "$fintech_task_runners"
            mkdir "$data_source_directory"
            
            cp -rf ./temp/neural-networks-and-deep-learning-master/src/* "$deep_learning_scripts_directory/"
            cp -rf ./temp/neural-networks-and-deep-learning-master/data/* "$data_source_directory"
            rm -rf temp
            
            # This mods the mnist_loader.py to change where the loader looks for the test data.
            local old_string="../data/mnist.pkl.gz"
            local new_string="$fintec_workspace_directory/fintech_test_data/mnist.pkl.gz"
            sed -i -e 's,'"$old_string"','"$new_string"',g' ./"$deep_learning_scripts_directory"/mnist_loader.py

            
            cd "$fintech_task_runners"
            mkdir "$data_deposit_directory"
            # create_base_python_script "$data_deposit_directory"
        fi

    fi
}

function create_base_python_script() {

cat > fintec_test_script.py <<EOL
import sys, os
sys.path.append(os.path.join(os.path.dirname(sys.path[0]),'finech_task_dependencies'))

import mnist_loader
import network

training_data, validation_data, test_data = mnist_loader.load_data_wrapper()

net = network.Network([784, 30, 10])

net.SGD(training_data, 5, 10, 3.0, test_data=test_data)

EOL
}

function create_script_runner() {

    local name_for_script_runner="script_runner.bash"
    local fintec_workspace_directory="fintec_workspace"
    cd $GOPATH

cat > "$name_for_script_runner"<<EOL
SCRIPT_OUTPUT_DIRECTORY="./$fintec_workspace_directory/fintech_task_runners/data_runners_created"

if [ -d "\$SCRIPT_OUTPUT_DIRECTORY" ]
then
    echo "Found : \$SCRIPT_OUTPUT_DIRECTORY"
else
    echo "Creating : \$SCRIPT_OUTPUT_DIRECTORY"
    mkdir "\$SCRIPT_OUTPUT_DIRECTORY"
fi

python $fintec_workspace_directory/fintech_task_runners/fintec_test_script.py > "\$SCRIPT_OUTPUT_DIRECTORY"/example_output_1.txt
python $fintec_workspace_directory/fintech_task_runners/example_script_1.py > "\$SCRIPT_OUTPUT_DIRECTORY"/example_output_2.txt
python $fintec_workspace_directory/fintech_task_runners/example_script_2.py > "\$SCRIPT_OUTPUT_DIRECTORY"/example_output_2.txt
python $fintec_workspace_directory/fintech_task_runners/example_script_3.py > "\$SCRIPT_OUTPUT_DIRECTORY"/example_output_3.txt
python $fintec_workspace_directory/fintech_task_runners/example_script_4.py > "\$SCRIPT_OUTPUT_DIRECTORY"/example_output_4.txt

python $fintec_workspace_directory/fintech_task_runners/example_script_6.1.py
EOL
}


get_update_and_do_upgrade

create_fintech_workspace "$fintec_workspace_directory"

#create_script_runner

# bash run_fintech_class_demo.bash

