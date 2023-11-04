import subprocess
import os


def run_asm_file(file_path, input_data):
    extra_spaces = 66
    try:
        for input in input_data:
            result = subprocess.run(["java", "-jar", "rars.jar", file_path], input=input, text=True,
                                    capture_output=True)
            print("Входные данные от пользователя:\n" + input, end='')
            print(result.stdout[extra_spaces:], '\n')
    except subprocess.CalledProcessError as e:
        print("Произошла ошибка:", e)


def main():
    asm_file_path = "ihw2.asm"

    test_data = [
        "-10\n",
        "0\n",
        "2\n",
        "1\n",
        "-1\n",
        "0.2\n",
        "0.5\n",
        "-0.999\n",
        "-0.1234\n",
        "0.561\n",
    ]

    if not os.path.exists("rars.jar"):
        print("Ошибка: Файл rars.jar не найден в текущем каталоге.")
        return

    run_asm_file(asm_file_path, test_data)


if __name__ == "__main__":
    main()
