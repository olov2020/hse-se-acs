import math

x = float(input())
true_ans = math.log(1 - x)    # usage of base func
print(true_ans)

ans = 0
cnt = 1
while cnt < 1000000:          # example of algorithm
    upper = x ** cnt
    ans -= upper / cnt
    cnt += 1

print(ans)

print(f'\n{true_ans / ans}')  # calculate accuracy
