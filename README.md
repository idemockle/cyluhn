# Cyluhn
A simple, fast library for verifying and calculating Luhn check digits, as well
as generating random serial numbers with valid Luhn check digits for testing.

Cyluhn is mostly a Cython port of the pure-Python [luhn](https://github.com/mmcloughlin/luhn)
library, acheiving a boost in speed while still being easy to install with pip.
Cyluhn is intended to reduce the amount of time needed to validate a large number
of Luhn-validated numbers such as credit card numbers or IMEIs during batch 
processing. 

Compatible with Python 2.7 and Python 3.

## Installation
```commandline
pip install cyluhn
```

## Usage
### Cyluhn module
```python
import cyluhn

cyluhn.generate_valid_luhn_str(ndigits=15)
# '136260325312871'

cyluhn.verify('136260325312871')
# True

cyluhn.get_check_digit('13626032531287')
# 1

cyluhn.append_check_digit('13626032531287')
# '136260325312871'
```
### cyluhn-generate Command-Line Utility
```
cyluhn-generate -h
usage: cyluhn-generate [-h] -d NDIGITS -n NSERIALS

Generate serial numbers with valid Luhn check digit

optional arguments:
  -h, --help            show this help message and exit
  -d NDIGITS, --ndigits NDIGITS
                        Number of digits in each generated serial number
  -n NSERIALS, --nserials NSERIALS
                        Number of serial numbers to generate
                        
Example:
cyluhn-generate -d 16 -n 10
7781801660482648
3204945043783442
6774339190776602
7715248262106681
7482722928054759
0435980693667196
6857863506381286
7743440795032247
8555647107058638
9772875170328167
```

## Runtime comparisons with luhn
```
%timeit cyluhn.generate_valid_luhn_str(15)
1.38 µs ± 8.93 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)

%timeit luhn.append(''.join(random.choices('0123456789', k=14)))
7.14 µs ± 40.4 ns per loop (mean ± std. dev. of 7 runs, 100000 loops each)
---
%timeit cyluhn.verify('136260325312871')
475 ns ± 6.13 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)

%timeit luhn.verify('136260325312871')
3.66 µs ± 77.6 ns per loop (mean ± std. dev. of 7 runs, 100000 loops each)
---
%timeit cyluhn.get_check_digit('13626032531287')
533 ns ± 4.35 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)

%timeit luhn.generate('13626032531287')
3.64 µs ± 24.7 ns per loop (mean ± std. dev. of 7 runs, 100000 loops each)
---
%timeit cyluhn.append_check_digit('13626032531287')
719 ns ± 4.05 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)

%timeit luhn.append('13626032531287')
3.88 µs ± 26.7 ns per loop (mean ± std. dev. of 7 runs, 100000 loops each)
```