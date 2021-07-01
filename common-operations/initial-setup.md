# Initial Setup

## Prerequisite

* Load python 3.7.1
  * `module load python/3.7.1`

## Install Toil into a Python Virtual Environment \(or venv\)

The main executor is `toil-cwl-runner`

\(Explain above more\)



### Install Toil in Python venv

To create a python venv, use the following command \(replacing `$VENV_PATH` with your venv path\).

```text
export VENV_PATH=<your venv path>
python3 -m venv $VENV_PATH
```

Source the venv:

```text
source $VENV_PATH/bin/activate
```

Install toil version 5.4.x:

```text
pip install "git+https://github.com/mskcc/toil.git@5.4.x#egg=toil[cwl]"
```

### Install Node.js

```python
# Setup node
unset NVM_DIR
mkdir ~/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
source ~/.nvm/nvm.sh
nvm install v12.4.0
```

