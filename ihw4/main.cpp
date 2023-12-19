#include <iostream>
#include <fstream>
#include <thread>
#include <vector>
#include <mutex>
#include <condition_variable>
#include <unordered_map>

using namespace std;

mutex mtx;
condition_variable cv;
int num_books = 0;
unordered_map<int, vector<int>> readers_books;
ifstream input_file("../input.txt");
ofstream output_file("../output.txt");

void librarian()
{
    unique_lock<mutex> lock(mtx);
    while (num_books == 0)
    {
        cout << "Librarian: No available books. Wait." << endl;
        output_file << "Librarian: No available books. Wait." << endl;
        cv.wait(lock);
    }
    num_books--;
    cout << "Librarian: Gives you a book. Rest of books: " << num_books << endl;
    output_file << "Librarian: Gives you a book. Rest of books: " << num_books << endl;
}

void reader(int id)
{
    int num_desired_books = rand() % 3 + 1;
    vector<int> books_taken;

    unique_lock<mutex> lock(mtx);
    cout << "Reader " << id << ": Comes ot the library. Wants to take " << num_desired_books << " books." << endl;
    output_file << "Reader " << id << ": Comes ot the library. Wants to take " << num_desired_books << " books." << endl;

    while (num_books < num_desired_books)
    {
        cout << "Reader " << id << ": There are no so many books. Waiting." << endl;
        output_file << "Reader " << id << ": There are no so many books. Waiting." << endl;
        cv.wait(lock);
    }

    for (int i = 0; i < num_desired_books; i++)
    {
        int book = rand() % num_books + 1; // Выбор случайной книги от 1 до num_books
        num_books--;
        books_taken.push_back(book);
    }
    readers_books[id] = books_taken;

    cout << "Reader " << id << ": Gets books: ";
    output_file << "Reader " << id << ": Gets books: ";
    for (int i = 0; i < num_desired_books; i++)
    {
        cout << books_taken[i] << " ";
        output_file << books_taken[i] << " ";
    }
    cout << ". Rest of books: " << num_books << endl;
    output_file << ". Rest of books: " << num_books << endl;

    lock.unlock();

    // Читатель читает книги в течение 3 дней
    this_thread::sleep_for(chrono::seconds(3));

    lock.lock();
    cout << "Reader " << id << ": Finished reading. Returns books." << endl;
    output_file << "Reader " << id << ": Finished reading. Returns books." << endl;

    for (int i = 0; i < num_desired_books; i++)
    {
        num_books++;
    }
    readers_books.erase(id);

    cout << "Reader " << id << ": Returns books. Rest of books: " << num_books << endl;
    output_file << "Reader " << id << ": Returns books. Rest of books: " << num_books << endl;

    if (num_books >= num_desired_books)
    {
        cv.notify_all();
    }
}

int main()
{
    int num_books, num_readers;
    input_file >> num_books >> num_readers;

    ::num_books = num_books;

    thread librarian_thread(librarian);

    thread* reader_threads = new thread[num_readers];
    for (int i = 0; i < num_readers; i++)
    {
        reader_threads[i] = thread(reader, i+1);
    }

    librarian_thread.join();

    for (int i = 0; i < num_readers; i++)
    {
        reader_threads[i].join();
    }

    delete[] reader_threads;

    return 0;
}