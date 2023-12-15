#include <iostream>
#include <chrono>
#include <random>
#include <thread>

#define uint unsigned int

uint random(uint a, uint b) {
    std::random_device dev;
    std::mt19937 rng(dev());
    std::uniform_int_distribution<std::mt19937::result_type> dist(a, b); // distribution in range [1, 6]
    return dist(rng);
}

void sleep(uint a, uint b) {
    std::chrono::milliseconds timespan(random(a, b)); // or whatever
    std::this_thread::sleep_for(timespan);
}

const uint arrSize = 100;

const int threadNumber = 20; // Количество потоков

//стартовая функция для дочерних потоков
void sqsum(int iThread, int iTN, int a, int *sum) {
    if (iTN == 0) {
        *sum = a;
        return;
    }
    *sum = *(sum - 1);
    *sum += a;
}

int main() {
    std::thread *thr[threadNumber];
    int sum[threadNumber];
    int arr[threadNumber];

    for (int i = 0; i < threadNumber; i++) {
        int a = static_cast<int>(random(1, 20));
        arr[i] = a;
        sleep(1, 7);
        thr[i] = new std::thread{sqsum, i, threadNumber, a, (sum + i)};
        // std::cout << *(sum + i) << "\n";
    }

    int rez = 0; //для записи окончательного результата

    // Завершение потоков
    std::cout << sum[0] << " = " << arr[0] << '\n';
    for (int i = 1; i < threadNumber; i++) {
        thr[i]->join();
        rez += sum[i];
        delete thr[i];
        std::cout << sum[i] << " = " << sum[i - 1] << " + " << arr[i] << '\n';
    }

    return 0;
}
