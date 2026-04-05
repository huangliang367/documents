# References

## Makefile 教程
  
```text
https://makefiletutorial.com/
```

```makefile
# Thanks to Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)
TARGET_EXEC := final_program

BUILD_DIR := ./build
SRC_DIRS := ./src

# Find all the C and C++ files we want to compile
# Note the single quotes around the * expressions. The shell will incorrectly expand these otherwise, but we want to send the * directly to the find command.
SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')

# Prepends BUILD_DIR and appends .o to every src file
# As an example, ./your_dir/hello.cpp turns into ./build/./your_dir/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP

# The final build step.
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
        $(CXX) $(OBJS) -o $@ $(LDFLAGS)

# Build step for C source
$(BUILD_DIR)/%.c.o: %.c
        mkdir -p $(dir $@)
        $(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Build step for C++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
        mkdir -p $(dir $@)
        $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean
clean:
        rm -r $(BUILD_DIR)

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS
```

## python package 制作发布流程

1. create package sturcture using `cookiecutter`

```shell
cookiecutter https://github.com/py-pkgs/py-pkgs-cookiecutter.git
```

1. put your package under version control
2. create and activate a virtural environment using conda

```shell
conda create --name <your-env-name> python=3.12 -y
conda activate <your-env-name>
```

4. Add python code to modules in the src directory, adding dependencise and needed

```shell
poetry add <dependency>
```

1. install and try your package in a python interpreter

```shell
poetry install
```

1. write tests for your package in modules prefixed with `test_` in `tests/` directory. Add `pytest` as
a development depency to run your tests. Add pytest-dev as a development dependency to calculate the
coverage of your tests.

```shell
poetry add --group dev pytest pytest-cov
pytest tests/ --cov=<pkg-name>
```

1. create documentation source files for your package. Use `sphinx` to compile and generate and HTML render of
your documention, adding the required development dependencies.

```shell
poetry ad --group dev jupyter myst-nb sphinx-autoapip sphinx-rtd-theme
cd docs
make html
cd ..
```

1. host documentation online with Read the Docs.
2. tag a release of your package using git and github, or equivalent version control tools.
3. build sdist and wheel distributions for your package

```shell
poetry build
```

1. publish your distributions to `TestPyPI` and try installing your package

```shell
poetry config repositories.test-pypi \
  https://test.pypi.org/legacy/
poetry publish -r test-pypi
pip install --index-url https://test.pypi.org/simple/ \
  --extra-index-url https://pypi.org/simple \
  pycounts
```

1. publish your distributions to `PyPI`. Your package can now be installed by anyone using `pip`

```shell
poetry publish
pip install <pkg-name>
```
