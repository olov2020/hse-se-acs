#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <vector>
#include <random>
#include <chrono>

std::mutex mtx; // мьютекс для синхронизации доступа к библиотеке
std::condition_variable cv; // условная переменная для ожидания появления нужной книги
std::vector<bool> books; // вектор, представляющий наличие книг в библиотеке

void librarian() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, 10);

    while (true) {
        std::this_thread::sleep_for(std::chrono::seconds(dis(gen)));

        std::unique_lock<std::mutex> lock(mtx);

        // выбираем случайную книгу для добавления в библиотеку
        int bookId = dis(gen) - 1;

        // добавляем книгу в библиотеку
        books[bookId] = true;

        std::cout << "Book " << bookId + 1 << " is available now" << std::endl;

        lock.unlock();
        cv.notify_all();
    }
}

void reader(int id) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, 3);

    while (true) {
        std::unique_lock<std::mutex> lock(mtx);

        // выбираем случайное количество книг для чтения
        int numBooks = dis(gen);

        // выбираем случайные книги для чтения
        std::vector<int> selectedBooks;
        for (int i = 0; i < numBooks; ++i) {
            int bookId = dis(gen) - 1;
            selectedBooks.push_back(bookId);
        }

        // проверяем наличие выбранных книг
        bool missingBooks = false;
        for (int bookId : selectedBooks) {
            if (!books[bookId]) {
                missingBooks = true;
                break;
            }
        }

        if (missingBooks) {
            // ожидаем появления нужной книги
            cv.wait(lock, [&selectedBooks]() {
                for (int bookId : selectedBooks) {
                    if (books[bookId]) {
                        return true;
                    }
                }
                return false;
            });
        }

        // читаем выбранные книги
        for (int bookId : selectedBooks) {
            if (books[bookId]) {
                std::cout << "Reader " << id << " is reading the book " << bookId + 1 << std::endl;
                std::this_thread::sleep_for(std::chrono::seconds(dis(gen)));
                std::cout << "Reader " << id << " finished reading the book " << bookId + 1 << std::endl;
            }
        }

        lock.unlock();
        cv.notify_all();
    }
}

int main() {
    int numBooks, numReaders;

    std::cout << "Input num of books: ";
    std::cin >> numBooks;

    std::cout << "Input num of readers: ";
    std::cin >> numReaders;

    books.resize(numBooks, true);

    std::vector<std::thread> threads;
    threads.emplace_back(librarian);
    for (int i = 0; i < numReaders; ++i) {
        threads.emplace_back(reader, i + 1);
    }

    for (std::thread& thread : threads) {
        thread.join();
    }

    return 0;
}