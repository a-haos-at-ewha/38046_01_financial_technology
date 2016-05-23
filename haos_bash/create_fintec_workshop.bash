cd $GOPATH

git config --global credential.helper 'cache --timeout=172800'

git clone https://github.com/a-haos-at-ewha/38046_01_financial_technology.git public_fintec
git clone https://gitlab.com/ewha_spring_2016/38046_01_financial_technology.git private_fintec

git clone https://gitlab.com/ewha_spring_2016/z_spring_2016_bash_toolset.git

bash public_fintec/haos_bash/build_a_fin_techy_haos.bash
