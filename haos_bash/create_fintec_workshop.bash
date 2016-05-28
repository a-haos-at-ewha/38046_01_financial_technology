function ask_user_to_continue() {
    read -p "Continue? (y/n) : " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Doing such."
    else
        echo "Goodbye!"
        exit 1
    fi
}

cd $GOPATH

git config --global credential.helper 'cache --timeout=172800'
#ask_user_to_continue

git clone https://github.com/a-haos-at-ewha/38046_01_financial_technology.git public_fintec
#ask_user_to_continue

git clone https://gitlab.com/ewha_spring_2016/38046_01_financial_technology.git private_fintec
#ask_user_to_continue

git clone https://gitlab.com/ewha_spring_2016/z_spring_2016_bash_toolset.git
#ask_user_to_continue

bash public_fintec/haos_bash/build_a_fin_techy_haos.bash
