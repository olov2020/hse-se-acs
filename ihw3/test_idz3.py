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
    asm_file_path = "ihw3.asm"

    test_data = [
        "a\n",
        "data/test.txt\n",
        "data/output.txt\n",
    ]

    if not os.path.exists("rars.jar"):
        print("Ошибка: Файл rars.jar не найден в текущем каталоге.")
        return

    run_asm_file(asm_file_path, test_data)


if __name__ == "__main__":
    main()
