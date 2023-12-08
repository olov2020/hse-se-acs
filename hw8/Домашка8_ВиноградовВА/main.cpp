#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <thread>

// const long long arrSize = 100000000000;
// const unsigned int arrSize = 500000000;
const unsigned int arrSize = 10000000;

double *A;
double *B;

// const int threadNumber = 1; // Количество потоков
// const int threadNumber = 2; // Количество потоков
// const int threadNumber = 4; // Количество потоков
// const int threadNumber = 8; // Количество потоков
const int threadNumber = 1000; // Количество потоков

//стартовая функция для дочерних потоков
void sqsum(int iThread, int iTN, double *arr, double *brr, int size, double *sum) {
// void sqsum(int iThread, int iTN, double *arr, int size, double &sum) {
    *sum = 0;
    // sum = 0;
    for (int i = iThread; i < size; i += iTN) {
        *sum += arr[i] * brr[i];
        // sum += arr[i] * brr[i];
    }
    // std::cout << "Поток " << iThread << "; Текущая сумма = " << *sum << "\n";
}

int main() {
    A = new double[arrSize];
    B = new double[arrSize];
    if (A == nullptr || B == nullptr) {
        std::cout << "Incorrect size of vector = " << arrSize << "\n";
        return 1;
    }
    for (int i = 0; i < arrSize; ++i) {
        A[i] = static_cast<double>(i + 1);
        B[i] = static_cast<double>(arrSize - i);
    }

    std::thread *thr[threadNumber];
    double sum[threadNumber];

    clock_t start_time = clock(); // начальное время

    // Создание потоков
    for (int i = 0; i < threadNumber; i++) {
        thr[i] = new std::thread{sqsum, i, threadNumber, A, B, arrSize, (sum + i)};
        // thr[i] = new std::thread{sqsum, i, threadNumber, A, B, arrSize, std::ref(sum[i])};
    }

    double rez = 0.0; //для записи окончательного результата

    // Завершение потоков
    for (int i = 0; i < threadNumber; i++) {
        thr[i]->join();
        rez += sum[i];
        delete thr[i];
    }

    clock_t end_time = clock(); // конечное время

    //вывод результата
    std::cout << "Произведение массивов = " << rez << "\n";
    std::cout << "Произведение массивов = " <<
              std::setprecision(20) << rez << "\n";
    std::cout << "Произведение массивов = " << std::scientific <<
              std::setprecision(std::numeric_limits<double>::digits10 + 1) << rez << "\n";

    std::cout << "Время счета и сборки = " << end_time - start_time << "\n";

    delete[] A;
    delete[] B;
    return 0;
}
