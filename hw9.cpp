#include <iostream>
#include <chrono>
#include <random>
#include <thread>
#include <pthread.h>
#include <semaphore.h>
#include <queue>

#define uint unsigned int

std::queue<int> buffer;
int sum;
bool is_summarizer_done = false;
pthread_mutex_t buffer_mutex = PTHREAD_MUTEX_INITIALIZER;
sem_t buffer_status;

const uint arrSize = 100;
const int threadNumber = 20; // Количество потоков

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

void *makeThreads(void *arg) {
    int thread_number = *((int *) arg);
    sleep(1, 7);
    pthread_mutex_lock(&buffer_mutex);
    int number = static_cast<int>(random(1, 20));
    buffer.push(number);
    std::cout << "Thread " << thread_number << ": " << number << std::endl;
    sem_post(&buffer_status);
    pthread_mutex_unlock(&buffer_mutex);
    return nullptr;
}

void *summ(void *arg) {
    sleep(3, 6);
    int num1 = buffer.front();
    buffer.pop();
    int num2 = buffer.front();
    buffer.pop();

    pthread_mutex_unlock(&buffer_mutex);
    sum = num1 + num2;

    pthread_mutex_lock(&buffer_mutex);
    buffer.push(sum);
    std::cout << "Current sum: " << sum << " = " << num2 << " + " << num1 << std::endl;
    sem_post(&buffer_status);
    pthread_mutex_unlock(&buffer_mutex);
    return nullptr;
}

void *fin(void *param) {
    while (true) {
        pthread_mutex_lock(&buffer_mutex);
        while (buffer.size() < 2 && !is_summarizer_done) {
            pthread_mutex_unlock(&buffer_mutex);
            sem_wait(&buffer_status);
            pthread_mutex_lock(&buffer_mutex);
        }

        if (is_summarizer_done && buffer.size() <= 1) {
            sum = buffer.front();
            std::cout << "Sum overall: " << sum << std::endl;
            pthread_mutex_unlock(&buffer_mutex);
            break;
        }
        pthread_t summarizer_thread;
        pthread_create(&summarizer_thread, nullptr, summ, nullptr);
        pthread_join(summarizer_thread, nullptr);
    }
    return nullptr;
}

int main() {
    pthread_mutex_init(&buffer_mutex, nullptr);
    sem_init(&buffer_status, 0, 0);

    pthread_t observer_thread;
    pthread_create(&observer_thread, nullptr, fin, nullptr);

    pthread_t producer_threads[threadNumber];

    for (int i = 0; i < threadNumber; ++i) {
        int *thread_number = new int(i + 1);
        pthread_create(&producer_threads[i], nullptr, makeThreads, thread_number);
    }

    for (int i = 0; i < threadNumber; ++i) {
        pthread_join(producer_threads[i], nullptr);
    }

    is_summarizer_done = true;
    sem_post(&buffer_status);
    pthread_join(observer_thread, nullptr);

    sem_destroy(&buffer_status);
    pthread_mutex_destroy(&buffer_mutex);

    return 0;
}
