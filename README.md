CL Machine-Learning
===================

### AUTHOR(s):    Salvi Péter, Naganuma Shigeta, Tada Masashi, Abe Yusuke, Jianshi Huang, Fujii Ryo, Abe Seika, Kuroda Hisao
### REPACKAGER:     Mike Maul

CL Machine-Learning is high performance and large scale statistical
machine learning package written in Common Lisp developed at MSI. 

This repository contains is a modified version of CLML with the following goals in mind:
* Remove dependent libraries available from the Quicklisp repository
* Re-factor code to support Quicklisp packaging 
* Organize code into independent systems based on functional category
* Add support for Clozure Common Lisp short term and CLisp and ECL long term
* Provide English language translation of existing documentation and enhance documentation

### Runtime Requirements
* Language: SBCL, Clozure Common Lisp, Allegro or Lispworks
* Platform: Posix compatibile platforms (Windows, Linux, BSD and derivatives)
* Optionally Intel Math Kernel Library

Currently development is taking place mostly on SBCL. For the near future SBCL is most stable platform.    
    
### Build Requirements
* Requires build infrastructure: ASDF3 and optionally Quicklisp (This document assumes Quicklisp)
* gcc compiler

Installation Notes
------------------
#### Obtain code
Clone this repository with
  git clone https://github.com/mmaul/clml.git
Or download zip archive at
  https://github.com/mmaul/clml/archive/master.zip

If using quicklisp place in local-projects directory

CAVEATS
-------
This repository is under very active development, and CLML is quite large.
Expect possible breakage, given the sheer size of clml, not all parts have
been tested, or will work. That said it is pretty functional as it stands.
    
Documentation
-------------
See README files in system directories. See code. I do however intend to provide
documentation.
    
Usage
-----
This library is orginized as a hierarchical tree of systems, currently with two root
nodes clml and hjs. hjs is the core.
    hjs
    clml
        association-rule
        blas
        classifiers
        clustering
        decision-tree
        demo
        docs
        graph
        hjs
        lapack
        nearest-search
        nonparametric
        notes
        numeric
        pca
        som
        statistics
        svm
        test
        text
        time-series
        utility

Each system can be loaded independantly or the the clml system can be loaded which contains
dependencies to all child system definitions.

This library requires that default reader float for mat is set to double-float. This should
be done before loading the systems.
    (setf *read-default-float-format* 'double-float)    

Here is a quick demonstration

CL-USER> (ql:quickload :clml)

CL-USER> (clml.text.utilities:calculate-levenshtein-similarity "Howdy" "doody")
    0.6
CL-USER> 
CL-USER> (setf *syobu* (hjs.learn.read-data:read-data-from-file "sample/syobu.csv" :type :csv 
                                                         :csv-type-spec
    						    '(string integer integer integer integer)))


    #<HJS.LEARN.READ-DATA:UNSPECIALIZED-DATASET >
    DIMENSIONS: 種類 | がく長 | がく幅 | 花びら長 | 花びら幅
    TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
    NUMBER OF DIMENSIONS: 5
    DATA POINTS: 150 POINTS

CL-USER> (setf *tree* (clml.decision-tree.decision-tree:make-decision-tree *syobu* "種類"))


(((("花びら長" . 30)
   (("花びら幅" . 18) ("花びら幅" . 23) ("花びら幅" . 20) ("花びら幅" . 19) ("花びら幅" . 25)
    ("花びら幅" . 24) ("花びら幅" . 21) ("花びら幅" . 14) ("花びら幅" . 15) ("花びら幅" . 22)
    ("花びら幅" . 16) ("花びら幅" . 17) ("花びら幅" . 13) ("花びら幅" . 11) ("花びら幅" . 12)
  ...
  (("Virginica" . 50) ("Versicolor" . 50) ("Setosa" . 50))
  ((149 148 147 146 145 144 143 142 141 140 139 138 137 136 135 134 133 132 131
  ...
 (((("花びら幅" . 18)
    (("花びら幅" . 23) ("花びら幅" . 20) ("花びら幅" . 19) ("花びら幅" . 25) ("花びら幅" . 24)
     ("花びら幅" . 21) ("花びら幅" . 14) ("花びら幅" . 15) ("花びら幅" . 22) ("花びら幅" . 16)
     ("花びら幅" . 17) ("花びら幅" . 13) ("花びら幅" . 11) ("花びら幅" . 12) ("花びら幅" . 10)
 ...
    
        )))
CL-USER> 
CL-USER>  (clml.decision-tree.decision-tree:print-decision-tree *tree*)
    [30 <= 花びら長?]((Virginica . 50) (Versicolor . 50) (Setosa . 50))
       Yes->[18 <= 花びら幅?]((Versicolor . 50) (Virginica . 50))
          Yes->[49 <= 花びら長?]((Virginica . 45) (Versicolor . 1))
             Yes->((Virginica . 43))
             No->[60 <= がく長?]((Versicolor . 1) (Virginica . 2))
                Yes->((Virginica . 2))
                No->((Versicolor . 1))
          No->[50 <= 花びら長?]((Virginica . 5) (Versicolor . 49))
             Yes->[16 <= 花びら幅?]((Versicolor . 2) (Virginica . 4))
                Yes->[70 <= がく長?]((Virginica . 1) (Versicolor . 2))
                   Yes->((Virginica . 1))
                   No->((Versicolor . 2))
                No->((Virginica . 3))
             No->[17 <= 花びら幅?]((Versicolor . 47) (Virginica . 1))
                Yes->((Virginica . 1))
                No->((Versicolor . 47))
       No->((Setosa . 50))

    

* Machine-Learning Packages
** Read-Data
   package of reading data for machine learning
*** Class
**** dataset (base class)
- accessor:
  - dataset-dimensions : info vector describes each column
**** unspecialized-dataset (dataset without column type)
- accessor:
  - dataset-points : data except column names
- parent: dataset
**** specialized-dataset (dataset with column type)
- parent: dataset
**** numeric-dataset (dataset which column type is numeric)
- accessor:
  - dataset-numeric-points : vector of numeric data
- parent: specialized-dataset
**** category-dataset (dataset which column type is category)
- accessor:
  - dataset-category-points : vector of numeric data
- parent: specialized-dataset
**** numeric-and-category-dataset (dataset which column type is category or numeric)
- accessor:
  - dataset-numeric-points : vector of numeric data
  - dataset-category-points : vector of category data
- parent: (numeric-dataset category-dataset)
*** read-data-from-file (filename &key (type :sexp) external-format csv-type-spec (csv-header-p t) (missing-value-check t) missing-values-list)
- return: <unspecialized-dataset>
- arguments:
  - filename		:	<string>
  - type		:	:sexp | :csv
  - external-format	:	<acl-external-format>
  - csv-header-p	:	<boolean>, the first line is column names or not. default is t.
  - csv-type-spec	:	<list symbol>, specifies type of each column, e.g. '(string integer double-float double-float)
  - missing-value-check :       <boolean>, whether or not missing value check. default is t.
  - missing-value-list  :       <list>, represents missing value, default is '(nil "" "NA")
- comment:
  - default external-format is :default when /type/ is :sexp, :932 when /type/ is :csv
  - CSV conforms [[http://www.ietf.org/rfc/rfc4180.txt?number=4180][RFC4180]].
    - a column value cannot include /return/ or /newline/.
*** pick-and-specialize-data ((d unspecialized-dataset) &key (range :all) except data-types)
- return: <numeric-dataset>, <category-dataset> or <numeric-and-category-dataset> (determined by /data-type/)
- arguments:
  - d			:	<unspecialized-dataset>
  - range		:	:all | <list integer>, specifies which column are picked up. e.g. '(0 1 3 4)
  - except		:	<list integer>, specifies which column are *not* picked up. e.g. '(2)
  - data-types		:	 list of data type. e.g. '(:category :numeric :numeric)
*** divide-dataset ((specialized-d specialized-dataset) &key divide-ratio random (range :all) except)
- return: (values of <unspecialized-dataset>, <numeric-dataset>, <category-dataset> or <numeric-and-category-dataset>)
- arguments:
  - d			:       <unspecialized-dataset> | <specialized-dataset>
  - divide-ratio        :       <list non-negative-integer>, specifies how to divide the data. e.g. '(1 2 3) means data will be divided into 1:2:3.
  - random              :       <boolean>, if t, order of line is random.
  - range		:	:all | <list integer>, specifies which column are picked up. e.g. '(0 1 3 4)
  - except		:	<list integer>, specifies which column are *not* picked up. e.g. '(2)
- comments:
  - devide-dataset divide data into ration specified by /divide-ratio/. \\
    you can choose or remove specified columns using /range/ or /except/.
  - order of line stay in the original order.
*** choice-dimensions (names data)
- return: <vector vector>
- arguments:
  - names  : <list string>, the list of column names
  - data   : <unspecialized-dataset> | <specialized-dataset>
- comments:
  - This function takes out the data of the columns which have names specified with /names/.
*** choice-a-dimension (name data)
- return: <vector>
- arguments:
  - name  : <string>, a name of column
  - data  : <unspecialized-dataset> | <specialized-dataset>
- comments:
  - This function takes out the data of the column which has name specified with /name/.
*** make-unspecialized-dataset (all-column-names data)
- return: <unspecialized-dataset>
- arguments:
  - all-column-names	:	<list string>
  - data		:	<vector vector>
*** dataset-cleaning (d &key interp-types outlier-types outlier-values)
- return: <numeric-dataset> | <category-dataset> | <numeric-and-category-dataset> 
- arguments:
  - d : <numeric-dataset> | <category-dataset> | <numeric-and-category-dataset>
  - interp-types-alist   : a-list (key: column name, datum: interpolation(:zero :min :max :mean :median :mode :spline)) | nil\\
  - outlier-types-alist  : a-list (key: column name, datum: outlier-verification(:std-dev :mean-dev :user :smirnov-grubbs :freq)) | nil\\
  - outlier-values-alist : a-list (key: outlier-verification datum: the value according to outlier-verification) | nil
- descriptions:
  - This function performs Outlier-verification and Interpolation.
    At first, outlier is detected then interpolate missing values and those outlier values.
  - Outlier verification\\
    Outlier verification execute on values of columns which specified by /key/ of /outlier-types-alist/, by the method specified by /datum/.\\
    When judged the outlier, it is substituted for the missing value. when /outlier-types-alist/ is nil, verification will not execute.\\
    Parameter for each verification method is specified by /outlier-values-alist/. \\
    If it is not specified, default value is taken.
    - Methods of Outlier verification
      - Methods for numerical column( :numeric )
        - Standard deviation (:std-dev)\\
          When the difference with the mean value is greater than n time standard deviation, it is assumed the outlier. 
          Default value for n is 3.
        - Mean deviation (:mean-dev)\\
          When the difference with the mean value is greater than n time mean deviation, it is assumed the outlier. 
          Default value for n is 3.
        - Smirnov-grubbs verification(:smirnov-grubbs)
          - reference: http://aoki2.si.gunma-u.ac.jp/lecture/Grubbs/Grubbs.html
          - Significance level is specified by parameter. Default value is 0.05.
        - specified by user(:user)\\
          The value specified for a parameter is assumed to be an outlier. It is necessary to specify the parameter. 
      - Methods for categorical column( :category )
        - frequency(:freq)\\
          Assume the threshold be total number of data times the parameter.
          And the value of frequency that is less than the threshold is assumed to be an outlier.\\
          Default value is 0.01.
        - specified by user (:user)\\
          The value specified for a parameter is assumed to be an outlier. It is necessary to specify the parameter. 
  - Interpolation
    Interpolate values of columns which specified by /key/ of /interp-types-alist/, by the method specified by /datum/.\\
    when /interp-types-alist/ is nil, interpolation will not execute.
    - Methods of Interpolation
      - Methods for numerical column( :numeric )
        - :zero, interpolated by 0
        - :min, interpolated by minimum
        - :max, interpolated by maximum
        - :mean, interpolated by mean
        - :median, interpolated by median
        - :spline, 3-dimensional Spline interpolation
          - reference: William H. Press "NUMERICAL RECIPES in C", Chapter3
      - Methods for categorical column( :category )
        - :mode, interpolated by most frequent value
*** make-bootstrap-sample-datasets (dataset &key number-of-datasets)
- return: <list <unspecialized-dataset> | <numeric-dataset> | <category-dataset> | <numeric-and-category-dataset>>
- arguments:
  - dataset : <unspecialized-dataset> | <numeric-dataset> | <category-dataset> | <numeric-and-category-dataset>
  - number-of-datasets : <positive-integer>, default is 10
- comments:
  - Make bootstrap sample data of the number specified with number-of-datasets.
  - reference: C.M.Bishop "Pattern Recognition and Machine Learning"
*** QUOTE sample usage
 READ-DATA(18): (setf dataset (read-data-from-file "sample/original-airquality.sexp"))
 #<UNSPECIALIZED-DATASET>
 DIMENSIONS: id | Ozone | Solar.R | Wind | Temp | Month | Day
 TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
 DATA POINTS: 153 POINTS

 READ-DATA(19): (setf dataset (pick-and-specialize-data
                               dataset :range :all
                               :data-types '(:category :numeric :numeric :numeric :numeric
                                             :category :category)))
 #<NUMERIC-AND-CATEGORY-DATASET>
 DIMENSIONS: id | Ozone | Solar.R | Wind | Temp | Month | Day
 TYPES:      CATEGORY | NUMERIC | NUMERIC | NUMERIC | NUMERIC | CATEGORY | CATEGORY
 CATEGORY DATA POINTS: 153 POINTS
 NUMERIC DATA POINTS: 153 POINTS

 READ-DATA(20): (dataset-numeric-points dataset)
 #(#(41.0 190.0 7.4 67.0) #(36.0 118.0 8.0 72.0) #(12.0 149.0 #.EXCL:*NAN-DOUBLE* 74.0) #(18.0 313.0 11.5 62.0) 
   #(#.EXCL:*NAN-DOUBLE* #.EXCL:*NAN-DOUBLE* 14.3 56.0) #(28.0 #.EXCL:*NAN-DOUBLE* 14.9 66.0) #(23.0 299.0 8.6 65.0)
   #(19.0 99.0 13.8 #.EXCL:*NAN-DOUBLE*) #(8.0 19.0 #.EXCL:*NAN-DOUBLE* #.EXCL:*NAN-DOUBLE*) #(#.EXCL:*NAN-DOUBLE* 194.0 8.6 69.0) ...)
 READ-DATA(21): (dataset-category-points dataset)
 #(#(1 5 1) #(2 5 2) #(3 5 3) #(4 0 0) #(5 5 5) #(6 5 6) #(7 5 7) #(8 5 8) #(9 5 9) #(10 5 10) ...)

 READ-DATA(22): (setf dataset 
                   (dataset-cleaning dataset 
                                     :interp-types '(nil :spline :min :max :median :mode :mode)
                                     :outlier-types '(nil :std-dev :mean-dev :smirnov-grubbs nil
                                                      :user :freq)
                                     :outlier-values '(nil 2d0 2d0 0.05d0 nil 5 nil)))
 #<NUMERIC-AND-CATEGORY-DATASET>
 DIMENSIONS: id | Ozone | Solar.R | Wind | Temp | Month | Day
 TYPES:      CATEGORY | NUMERIC | NUMERIC | NUMERIC | NUMERIC | CATEGORY | CATEGORY
 CATEGORY DATA POINTS: 153 POINTS
 NUMERIC DATA POINTS: 153 POINTS
 READ-DATA(23): (dataset-numeric-points dataset)
 #(#(41.0 190.0 7.4 67.0) #(36.0 118.0 8.0 72.0) #(12.0 149.0 20.7 74.0) #(18.0 313.0 11.5 62.0) #(27.093168555852095 36.0 14.3 56.0)
   #(28.0 36.0 14.9 66.0) #(23.0 299.0 8.6 65.0) #(19.0 99.0 13.8 79.0) #(8.0 36.0 20.7 79.0)
   #(2.4104000463381468 194.0 8.6 69.0) ...)
 READ-DATA(24): (dataset-category-points dataset)
 #(#(1 8 1) #(2 8 2) #(3 8 3) #(4 8 30) #(5 8 5) #(6 8 6) #(7 8 7) #(8 8 8) #(9 8 9) #(10 8 10) ...)

 READ-DATA(25): (divide-dataset dataset :divide-ratio '(3 2) :except '(2 3 4))
 #<NUMERIC-AND-CATEGORY-DATASET>
 DIMENSIONS: id | Ozone | Month | Day
 TYPES:      CATEGORY | NUMERIC | CATEGORY | CATEGORY
 CATEGORY DATA POINTS: 91 POINTS
 NUMERIC DATA POINTS: 91 POINTS
 #<NUMERIC-AND-CATEGORY-DATASET>
 DIMENSIONS: id | Ozone | Month | Day
 TYPES:      CATEGORY | NUMERIC | CATEGORY | CATEGORY
 CATEGORY DATA POINTS: 62 POINTS
 NUMERIC DATA POINTS: 62 POINTS

 READ-DATA(26): (choice-dimensions '("Day" "Month" "Temp" "Wind") dataset)
 #(#(1 8 67.0 7.4) #(2 8 72.0 8.0) #(3 8 74.0 20.7) #(30 8 62.0 11.5) #(5 8 56.0 14.3) #(6 8 66.0 14.9) 
   #(7 8 65.0 8.6) #(8 8 79.0 13.8) #(9 8 79.0 20.7) #(10 8 69.0 8.6) ...)
 READ-DATA(27): (choice-a-dimension "Ozone" dataset)
 #(41.0 36.0 12.0 18.0 27.093168555852095 28.0 23.0 19.0 8.0 2.4104000463381468 ...)

 READ-DATA(26): (make-bootstrap-sample-datasets dataset :number-of-datasets 3)
 (#<NUMERIC-AND-CATEGORY-DATASET>
 DIMENSIONS: id | Ozone | Solar.R | Wind | Temp | Month | Day
 TYPES:      CATEGORY | NUMERIC | NUMERIC | NUMERIC | NUMERIC | CATEGORY | CATEGORY
 CATEGORY DATA POINTS: 153 POINTS
 NUMERIC DATA POINTS: 153 POINTS
  #<NUMERIC-AND-CATEGORY-DATASET>
 DIMENSIONS: id | Ozone | Solar.R | Wind | Temp | Month | Day
 TYPES:      CATEGORY | NUMERIC | NUMERIC | NUMERIC | NUMERIC | CATEGORY | CATEGORY
 CATEGORY DATA POINTS: 153 POINTS
 NUMERIC DATA POINTS: 153 POINTS
  #<NUMERIC-AND-CATEGORY-DATASET>
 DIMENSIONS: id | Ozone | Solar.R | Wind | Temp | Month | Day
 TYPES:      CATEGORY | NUMERIC | NUMERIC | NUMERIC | NUMERIC | CATEGORY | CATEGORY
 CATEGORY DATA POINTS: 153 POINTS
 NUMERIC DATA POINTS: 153 POINTS
 )

 ;; make unspecialized-dataset from vector
 READ-DATA(11): sample-vec
 #(#("1967 DEC" 1720) #("1968 JAN" 1702) #("1968 FEB" 1707) #("1968 MAR" 1708) #("1968 APR" 1727)
   #("1968 MAY" 1789) #("1968 JUN" 1829) #("1968 JUL" 1880) #("1968 AUG" 1920) #("1968 SEP" 1872) ...)
 READ-DATA(12): (make-unspecialized-dataset '("Year Month" "Amount of food") ;; column names
                                            sample-vec)
 #<UNSPECIALIZED-DATASET >
 DIMENSIONS: Year Month | Amount of food
 TYPES:      UNKNOWN | UNKNOWN
 NUMBER OF DIMENSIONS: 2
 DATA POINTS: 156 POINTS

** Principal-Component-Analysis
*** Class
**** pca-result (the result of principle component analysis)
- accessor:
 - components		:       <vector of datapoints>, principle components、score	
 - contributions	:       <vector of double-float>
 - loading-factors	:       <matrix>  (pay attention the representation of the matrix is row major)
 - pca-method		:       :covariance | :correlation
**** pca-model (for calculating score)
- accessor:
 - loading-factors	:       <matrix>, (pay attention the representation of the matrix is row major)
 - pca-method		:       :covariance | :correlation
*** princomp (dataset &key (method :correlation))
- return: (values pca-result pca-model)
- arugments:
  - dataset		:	<numeric-dataset>
  - method		:	:covariance | :correlation
*** princomp-projection (dataset pca-model)
- return: score (vector of datapoints)
- arguments:
  - dataset		:	<numeric-dataset>
  - pca-model		:	<pca-model>, model by P.C.A.
*** sub-princomp (dataset &key (method :correlation) (dimension-thld 0.8d0))
- return: (values pca-result pca-model)
- arugments:
  - dataset		:	<numeric-dataset>
  - method		:	:covariance | :correlation
  - dimension-thld : 0 < <number> < 1 | 1 <= <integer>, threshold for deciding principal components
- note:
  - When 0 < /dimension-thld/ < 1, it means the threshold for accumulated
    contribution ratio. A principle component's contribution ratio means
    its proportion in all principle components' contributions.
  - When 1 <= /dimension-thld/ ( integer ), it means the number of principle components.
*** make-face-estimator ((face-dataset numeric-and-category-dataset)
                         &key id-column dimension-thld method
                              pca-method d-fcn pca-result pca-model)
- return: (values estimator hash)
- arguments:
  - face-dataset : <numeric-and-category-dataset>
  - id-column : <string>, the name for the face ID column, default value is "personID"
  - dimension-thld : 0 < <number> < 1 | 1 <= <integer>, the threshold for determining the number of dimensions to use.
  - method : :eigenface | :subspace, method for face recognition, eigenface or subspace method.
  - pca-method : :covariance | :correlation, only valid when method is :subspace 
  - d-fcn : distance function for eigenface, default value is euclid-distance
  - pca-result : <pca-result>, necessary for :eigenface
  - pca-model : <pca-model>, necessary for :eigenface
- note:
  - When 0 < /dimension-thld/ < 1, it means the threshold for accumulated
    contribution ratio. A principle component's contribution ratio means
    its proportion in all principle components' contributions.
  - When 1 <= /dimension-thld/ ( integer ), it means the number of principle components.
- reference:
  - [[http://www.ism.ac.jp/editsec/toukei/pdf/49-1-023.pdf][坂野 鋭 "パターン認識における主成分分析 顔画像認識を例として" ]]
  - [[http://www.face-rec.org/][Face Recognition Homepage]]
    
*** face-estimate ((d numeric-dataset) estimator)
- return: <numeric-and-category-dataset>
- arguments:
  - d : <numeric-dataset>
  - estimator : <closure>, the first return value for make-face-estimator
*** Note
- when using princomp and sub-princomp, if there exists two columns
  that are of same value, the result for :correlation 
  method will not be converged. Therefore pick-and-specialize-data or
  divide-dataset must be used to remove one column.
*** QUOTE sample usage
PCA(10): (setf dataset (read-data-from-file "sample/pos.sexp" :external-format #+allegro :932 #-allegro :sjis))
PCA(11): (setf dataset (pick-and-specialize-data dataset :range '(2 3) :data-types '(:numeric :numeric)))
PCA(12): (princomp dataset :method :correlation)
 #<PCA-RESULT @ #x20fcd88a>
 #<PCA-MODEL @ #x20fcd8c2>
PCA(13): (princomp-projection dataset (cadr /))
 #(#(-0.18646787691278618 -0.5587877417431286)
  #(-0.2586922124306382 -0.6310120772609806)
  #(0.08929776779173992 -0.2830220970386028)
  #(-0.311219001898167 -0.6835388667285094)
  #(-0.19303372559622725 -0.5653535904265697)
  #(-0.19303372559622725 -0.5653535904265697)
  #(-0.19303372559622725 -0.5653535904265697)
  #(-1.9046466459275095 1.014942356235892)
  #(0.20748304409367965 -0.1648368207366632)
  #(0.161522103309592 -0.21079776152075083) ...)

;; learning and estimation by eigenface method and data for eyes
PCA(40): (let ((eyes (pick-and-specialize-data
                      (read-data-from-file "sample/eyes200.sexp")
                      :except '(0)
                      :data-types (append (make-list 1 :initial-element :category)
                                          (make-list 1680 :initial-element :numeric)))))
           (multiple-value-setq (for-learn for-estimate)
             (divide-dataset eyes :divide-ratio '(1 1) :random t)))

PCA(43): (multiple-value-setq (pca-result pca-model)
             (princomp (divide-dataset for-learn :except '(0)) :method :covariance))

PCA(65): (loop for dimension in '(1 5 10 20 30)
             as estimator = (make-face-estimator for-learn :dimension-thld dimension :method :eigenface
                                                 :pca-result pca-result :pca-model pca-model)
             as result = (face-estimate for-estimate estimator)
             do (format t "hitting-ratio: ~,3F~%"
                        (/ (count-if (lambda (p) (string-equal (aref p 0) (aref p 1)))
                                     (dataset-category-points result))
                           (length (dataset-points result)))))
Dimension : 1
Number of self-misjudgement : 53
hitting-ratio: 0.580
Dimension : 5
Number of self-misjudgement : 21
hitting-ratio: 0.860
Dimension : 10
Number of self-misjudgement : 18
hitting-ratio: 0.880
Dimension : 20
Number of self-misjudgement : 15
hitting-ratio: 0.890
Dimension : 30
Number of self-misjudgement : 13
hitting-ratio: 0.890

** K-means
*** k-means ((k integer) (dataset numeric-dataset) &key (distance-fn *distance-function*) standardization (max-iteration *max-iteration*) (num-of-trials *num-of-trials*) (random-state *random-state*) debug)
- return: (best-result table)
  - best-result		:	points, clusters, distance infomation, etc.
  - table		:	lookup table for normalized vecs and original vecs, might be removed later.
- arguments:
  - k			:	<integer>, number of clusters
  - dataset		:	<numeric-dataset> | <category-dataset> | <numeric-or-category-dataset>
  - distance-fn		:	#'euclid-distance | #'manhattan-distance | #'cosine-distance
  - standardization	:	t | nil, whether to standardize the inputs
  - max-iteration	:	maximum number of iterations of one trial
  - num-of-trials	:	number of trials, every trial changes the initial position of the clusters
  - random-state	:	(for testing), specify the random-state of the random number generator
  - debug		:	(for debugging) print out some debugging information
*** QUOTE sample usage
K-MEANS(22): (setf dataset (read-data-from-file "sample/pos.sexp" :external-format #+allegro :932 #-allegro :sjis))
K-MEANS(23): (setf dataset (pick-and-specialize-data dataset :range '(2 3) :data-types '(:numeric :numeric)))
K-MEANS(24): (k-means 20 dataset :distance-fn #'manhattan-distance)
 #S(PROBLEM-WORKSPACE :POINTS #(#S(POINT
                                  :ID
                                  0
                                  :POS
                                  #(1.0 129.0)
                                  :OWNER
                                  #S(CLUSTER
                                     :ID
                                     16
                                     :CENTER
                                     #(1.2455357142857142
                                       129.12321428571428)
                                     :OLD-CENTER
                                     #(1.2455357142857142
                                       129.12321428571428)
                                     :SIZE
                                     1120))
                               ...)
                     :CLUSTERS #(#S(CLUSTER
                                    :ID
                                    0
                                    :CENTER
                                    #(1.0831024930747923 110.0)
                                    :OLD-CENTER
                                    #(1.0831024930747923 110.0)
                                    :SIZE
                                    361)
                                 ...)
                     :DISTANCE-BETWEEN-CLUSTERS #2A((1.7976931348623157e+308
                                                     124.38037357745417
                                                     174.4273053916255
                                                     151.26611354279854
                                                     13.21191276633519
                                                     111.08310249307479
                                                     238.6819189661527
                                                     294.1850209583026
                                                     2920.083102493075
                                                     35.26307380581604
                                                     ...)
                                                    ...)
                     :DISTANCE-BETWEEN-POINT-AND-OWNER #(0.36874999999999747
                                                         0.17974882260597758
                                                         11.982608695652175
                                                         0.08310249307479234
                                                         0.347715736040624
                                                         0.347715736040624
                                                         0.347715736040624
                                                         1.9458398744113148
                                                         6.437807183364839
                                                         0.9826086956521745
                                                         ...)
                     :LOWER-BOUNDS ...)
 NIL
** Cluster-Validation
*** QUOTE Parameter
 *workspace* | validation target, the result of k-means clustering
*** calinski (&optional (*workspace* *workspace*))
- return: <number> cluster validity index
*** hartigan (&optional (*workspace* *workspace*))
- return: <number> cluster validity index
*** ball-and-hall (&optional (*workspace* *workspace*))
- return: <number> cluster validity index
*** dunn-index (&key (*workspace* *workspace*)
                     (distance :manhattan)
                     (intercluster :centroid)
                     (intracluster :centroid))
- return: <number> cluster validity index
- arguments:
  - distance: :manhattan | :euclid | :cosine
  - intercluster: :single | :complete | :average | :centroid | :average-to-centroids | :hausdorff
  - intracluster: :complete | :average | :centroid
*** davies-bouldin-index (&key (*workspace* *workspace*)
                               (distance :manhattan)
                               (intercluster :centroid)
                               (intracluster :centroid))
- return: <number> cluster validity index
- arguments:
  - distance: :manhattan | :euclid | :cosine
  - intercluster: :single | :complete | :average | :centroid | :average-to-centroids | :hausdorff
  - intracluster: :complete | :average | :centroid
*** global-silhouette-value (&key (*workspace* *workspace*)
                                  (distance :manhattan))
- return: <number> cluster validity index
- arguments:
  - distance: :manhattan | :euclid | :cosine
*** QUOTE sample usage
 CLUSTER-VALIDATION(72): (setf *workspace*
                          (k-means:k-means
                           5
                           (read-data:pick-and-specialize-data
                            (read-data:read-data-from-file
                             "sample/syobu.csv" :type :csv
                             :csv-type-spec '(string integer integer integer integer)
                             :external-format #+allegro :932 #-allegro :sjis)
                            :except '(0) :data-types (make-list 4
                                                                :initial-element :numeric))))
 CLUSTER-VALIDATION(73): (calinski)
 441.8562453167574
 CLUSTER-VALIDATION(74): (hartigan)
 2.5074656538807023
 CLUSTER-VALIDATION(75): (ball-and-hall)
 1127.7702976190476
 CLUSTER-VALIDATION(76): (dunn-index :distance :euclid
                                     :intercluster :hausdorff
                                     :intracluster :centroid)
 1.2576613811360222
 CLUSTER-VALIDATION(77): (davies-bouldin-index :distance :euclid
                                               :intercluster :average
                                               :intracluster :complete)
 1.899415427296523
 CLUSTER-VALIDATION(78): (global-silhouette-value :distance :euclid)
 0.5786560352400679
*** reference
- [[http://www.msi.co.jp/vmstudio/materials/tech/index.html][VMS Technical Reference]]
- [[http://www.cs.tcd.ie/publications/tech-reports/reports.02/TCD-CS-2002-33.pdf][Cluster validation techniques for genome expression data]]
** Linear-Regression
   linear regression package
*** mlr (numeric-dataset range)
- return: <SIMPLE-ARRAY DOUBLE-FLOAT (*)>, intercept and coefficients of multiple regression formula
- arguments:
  - numeric-dataset : <NUMERIC-DATASET>
  - range : <list>, '(indices of explanatory variables, index of objective variable)
*** QUOTE sample usage
 LINEAR-REGRESSION(128):(setf dataset (read-data-from-file "sample/airquality.csv"
			       :type :csv
			       :csv-type-spec 
			       '(integer double-float double-float double-float double-float integer integer)))
 #<UNSPECIALIZED-DATASET>
 DIMENSIONS: id | Ozone | Solar | Wind | Temp | Month | Day
 TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
 DATA POINTS: 111 POINTS
 LINEAR-REGRESSION(129):(setf airquality (pick-and-specialize-data dataset :range '(0 1 2 3 4) 
				    :data-types '(:numeric :numeric :numeric :numeric :numeric)))
 #<NUMERIC-DATASET>
 DIMENSIONS: id | Ozone | Solar | Wind | Temp
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
 NUMERIC DATA POINTS: 111 POINTS
 LINEAR-REGRESSION(130):(mlr airquality '(2 3 4 1))
 #(-64.34207892859138 0.05982058996849854 -3.333591305512754 1.6520929109927098)
** Hierarchical-Clustering
   hierarchical-clustering package
*** cophenetic-matrix (distance-matrix &optional (method #'hc-average))
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* * )), (SIMPLE-ARRAY T (* *)), cophenetic matrix and merge matrix
- arguments:
  - distance-matrix : (SIMPLE-ARRAY DOUBLE-FLOAT (* *))
  - method : hc-single | hc-complete | hc-average | hc-centroid | hc-median | hc-ward, default is average
*** cutree (k merge-matrix)
- return: (SIMPLE-ARRAY T), cluster label vector
- arguments:
  - k : the number of clusters, to divide dendrogram into k pieces
  - merge-matrix
*** QUOTE sample usage
HC(35): (setf data (read-data-from-file "sample/seiseki.csv"
					:type :csv :csv-type-spec
					'(string double-float double-float double-float double-float double-float)))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: name | math | science | japanese | english | history
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 7 POINTS
HC(36): (setf seiseki (pick-and-specialize-data data :range '(1 2 3 4 5)
						:data-types '(:numeric :numeric :numeric :numeric :numeric)))
 #<NUMERIC-DATASET>
DIMENSIONS: math | science | japanese | english | history
TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
NUMERIC DATA POINTS: 7 POINTS
HC(37): (setf distance-matrix (distance-matrix (numeric-matrix seiseki)))
 #2A((0.0 68.65857557508748 33.77869150810907 60.13318551349163 28.478061731796284 63.37191807101944 67.88225099390856)
    (68.65857557508748 0.0 81.11103500757464 64.1404708432983 60.753600716336145 12.409673645990857 38.1051177665153)
    (33.77869150810907 81.11103500757464 0.0 52.67826876426369 21.307275752662516 75.66372975210778 87.53856293085921)
    (60.13318551349163 64.1404708432983 52.67826876426369 0.0 47.10626285325551 54.31390245600108 91.53141537199127)
    (28.478061731796284 60.753600716336145 21.307275752662516 47.10626285325551 0.0 56.382621436041795 67.72739475278819)
    (63.37191807101944 12.409673645990857 75.66372975210778 54.31390245600108 56.382621436041795 0.0 45.58508528016593)
    (67.88225099390856 38.1051177665153 87.53856293085921 91.53141537199127 67.72739475278819 45.58508528016593 0.0))
HC(38): (multiple-value-setq (u v) (cophenetic-matrix distance-matrix #'hc-ward))
 #2A((0.0 150.95171411164776 34.40207690904939 66.03152040007744 34.40207690904939 150.95171411164776 150.95171411164776)
    (150.95171411164776 0.0 150.95171411164776 150.95171411164776 150.95171411164776 12.409673645990857 51.65691081579053)
    (34.40207690904939 150.95171411164776 0.0 66.03152040007744 21.307275752662516 150.95171411164776 150.95171411164776)
    (66.03152040007744 150.95171411164776 66.03152040007744 0.0 66.03152040007744 150.95171411164776 150.95171411164776)
    (34.40207690904939 150.95171411164776 21.307275752662516 66.03152040007744 0.0 150.95171411164776 150.95171411164776)
    (150.95171411164776 12.409673645990857 150.95171411164776 150.95171411164776 150.95171411164776 0.0 51.65691081579053)
    (150.95171411164776 51.65691081579053 150.95171411164776 150.95171411164776 150.95171411164776 51.65691081579053 0.0))
HC(39): (cutree 3 v)
 #(1 2 1 3 1 2 2)
** Non-negative-Matrix-Factorization
   non-negative matrix factorization package
*** nmf (non-negative-matrix k &key (cost-fn :euclidean) (iteration 100))
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* *)), two factor matrices obtained by nmf
- arguments:
  - non-negative-matrix : (SIMPLE-ARRAY DOUBLE-FLOAT (* *))
  - k : size of dimension reduction or number of features
  - cost-fn : :euclidean | :kl , default is euclidean
  - iteration : default is 100
- comments : we can choose Kullback–Leibler divergence as a cost function
- reference :
  [[http://cl-www.msi.co.jp/solutions/knowledge/lisp-world/tutorial/NMF.pdf][NMF package on CL-Machine Learning]]
*** QUOTE sample usage
NMF(113): (setf matrix (sample-matrix 4 4))
 #2A((5.0 33.0 13.0 29.0) (55.0 84.0 74.0 96.0) (11.0 69.0 92.0 48.0) (15.0 86.0 36.0 89.0))
NMF(114): (multiple-value-setq (weight feature) (nmf matrix 3 :iteration 80))
 #2A((0.1706700616740593 2.8780911735531785 0.9590208453512624)
    (2.04316650967508 0.9205577182615349 2.177706505047263)
    (0.45460124650102984 0.8208500118171567 9.364639376361005)
    (0.6081182025287406 7.873531632669753 2.0094667372957074))
NMF(115): feature
 #2A((26.64452775384442 32.373333937257556 27.1225512002247 41.13741018340651)
    (8.205335826063113e-6 7.186521221246216 0.2535892468154233 7.415674453785212)
    (7.798828607758656e-5 5.166396186586663 8.485528725251449 2.44838404009116))
NMF(116): (m*m weight feature)
 #2A((4.54752160312147 31.163303833367888 13.496659390410713 30.71196285636883)
    (54.43938416184624 84.010613867982 74.12832291141632 96.20899698701007)
    (12.113372596853665 68.99745115344638 92.00202074988742 47.716508000514054)
    (16.203243644732968 86.65181709675957 35.541747762140545 88.3239016155684))
NMF(117): (multiple-value-setq (weight feature) (nmf matrix 3 :cost-fn :kl))
 #2A((0.043068086218311506 0.05615058329446132 0.16029572873360276)
    (0.21249176355212562 0.6796882407264663 0.1811889159952452)
    (0.6443337004127561 0.08444888547870807 0.2125582079281919)
    (0.10010644981680689 0.1797122905003643 0.4459571473429601))
NMF(118): feature
 #2A((6.478155493510353 45.81284687065614 125.70077558823121 10.819729810945052)
    (78.61488727127733 66.63762341406404 62.441606842405456 96.81364930861258)
    (0.9069572352123124 159.54952971527982 26.85761756936332 154.36662088044235))
NMF(119): (m*m weight feature)
 #2A((4.838654906189247 31.289921197802457 13.224985867116567 30.646437922074924)
    (54.974499708007016 83.93626798604987 74.01750800106926 96.0717231487415)
    (11.00581471766063 69.05979629094608 91.97517704462386 47.959213628068696)
    (15.18103066814309 87.71401452520158 35.782329087190305 87.32262530111485)) 
*** nmf-sc (non-negative-matrix k sparseness &key type (iteration 100))
- non-negative matrix factorization with sparseness constraints
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* * )), two factor matrices obtained by nmf
- arguments:
  - non-negative-matrix : (SIMPLE-ARRAY DOUBLE-FLOAT (* * ))
  - k : size of dimension reduction
  - sparseness 0.0~1.0
  - type : :left | :right 
  - iteration : default is 100
- comments : we do nmf with sparseness constrained for the left factor matrix each column vector or right factor matrix each row vector. Objective function is euclidean norm.
- reference: [[http://www.cs.helsinki.fi/u/phoyer/papers/pdf/NMFscweb.pdf][Non-negative Matrix Factorization with Sparseness Constraints]]
*** QUOTE sample usage
NMF(34): (setf x (sample-matrix 100 100))
 #2A((70.0 65.0 68.0 42.0 35.0 20.0 51.0 7.0 25.0 9.0 ...)
    (44.0 83.0 39.0 37.0 32.0 74.0 32.0 23.0 27.0 42.0 ...)
    (57.0 97.0 96.0 23.0 56.0 67.0 27.0 19.0 90.0 89.0 ...)
    (55.0 6.0 32.0 78.0 59.0 58.0 34.0 63.0 66.0 7.0 ...)
    (66.0 92.0 63.0 65.0 63.0 75.0 36.0 7.0 79.0 77.0 ...)
    (75.0 86.0 95.0 73.0 66.0 86.0 61.0 34.0 7.0 43.0 ...)
    (11.0 39.0 87.0 31.0 4.0 52.0 64.0 57.0 8.0 23.0 ...)
    (84.0 52.0 49.0 68.0 75.0 14.0 21.0 73.0 57.0 77.0 ...)
    (93.0 85.0 28.0 22.0 98.0 2.0 61.0 48.0 45.0 7.0 ...)
    (81.0 51.0 5.0 36.0 87.0 12.0 84.0 53.0 35.0 78.0 ...)
    ...)
NMF(35): (multiple-value-setq (w h) (nmf-sc x 3 0.7 :type :left))
 #2A((1.4779288903810084e-12 3698.436810921221 508.76839564873075)
    (0.06468571444133886 0.0 4.206412995699793e-12)
    (15616.472155017571 5522.3359228859135 13359.214293446286)
    (0.5537530076878738 0.0030283688683994114 0.46633231671876274)
    (7472.121463556481 0.0 8687.743649034346)
    (866.1770680973686 6831.896141533997 4459.0733598676115)
    (1.5181766737885027 0.4388556634212364 0.727139819117383)
    (0.7198025410086757 0.0047792056984690134 4.206412995699793e-12)
    (1.4779288903810084e-12 0.0 4.206412995699793e-12)
    (0.25528585009283233 0.0 4.206412995699793e-12)
    ...)
NMF(36): h
 #2A((0.00287491870133676 0.0026133720724571797 2.950874161225484e-5 0.005125487883511961 6.757515335801653e-4
     0.0012968322406142806 0.0038001301816957284 0.002985585252159595 0.0081124151768938 0.0042303781451423035 ...)
    (0.004994350656772211 0.0025747747712995227 0.007134096369763904 0.0065746407124065084 0.0038636664279363847
     0.004880229457827016 0.00512112561086382 0.0038194228552171946 0.0050556422535574476 0.003237070939818787 ...)
    (0.0052939720030634446 0.007382671590128047 0.007556184152626243 3.931389819873203e-6 0.004546870255049726
     0.006931587163470776 2.239987792302906e-4 0.001349836871839297 1.94285681454748e-4 0.004391868346075027 ...))
NMF(37): (sparseness (pick-up-column w 0))
0.7
NMF(38): (multiple-value-setq (w h) (nmf-sc x 3 0.9 :type :right))
 #2A((8.289561664219266e-6 1.4361785459627462e-4 3.2783650074466155e-9)
    (8.963543606154278e-5 2.46840968396353e-5 2.181734037947416e-6)
    (2.9872365277908504e-5 1.412292680612174e-4 4.198406652155696e-5)
    (6.890230812495509e-13 7.954471346549545e-5 2.7910446164534665e-5)
    (1.2477626056283604e-4 4.292564917625326e-9 2.5310616226879616e-5)
    (3.619705865699883e-7 1.464351885312363e-4 7.522900946233666e-5)
    (4.19655080884389e-7 1.6289294924375495e-4 3.153712985065881e-5)
    (1.703028808790872e-8 5.8687333880722456e-5 1.2797257648598223e-4)
    (1.4373147157245112e-5 6.128539811119244e-7 9.512691095539368e-5)
    (2.029113599202957e-18 8.421240673252468e-17 1.0537112796313751e-4)
    ...)
NMF(39): h
 #2A((0.0 0.0 559651.4985471596 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
    (0.0 0.006235745138837956 588285.0338912416 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
    (0.0030094219837337732 0.0 336606.15256656246 0.0 0.0 0.0 0.0 0.0 6.607186514884233e-5 0.0 ...))
NMF(40): (sparseness (pick-up-row h 0))
0.8999999999999999
*** nmf-clustering (non-negative-matrix k &key (type :row) (cost-fn :euclidean) (iteration 100))
- clustering using nmf, each row or column datum is placed into cluster corresponding to highest feature
- return: (SIMPLE-ARRAY T (*)), cluster label vector
- arguments :
   - non-negative-matrix : (SIMPLE-ARRAY DOUBLE-FLOAT (* *))
   - k : number of features
   - type : :row | :column, default is row data clustering
   - cost-fn : :euclidean | :kl, default is euclidean
   - iteration : default is 100
- comments : obtained each cluster size is not always constant (not like k-means)
*** QUOTE sample usage
NMF(136): (setf x (sample-matrix 7 10))
 #2A((90.0 89.0 21.0 40.0 30.0 21.0 44.0 24.0 1.0 51.0)
    (1.0 64.0 5.0 90.0 66.0 69.0 89.0 29.0 95.0 80.0)
    (52.0 11.0 87.0 30.0 26.0 56.0 27.0 74.0 16.0 3.0)
    (90.0 10.0 92.0 16.0 54.0 75.0 48.0 22.0 73.0 71.0)
    (66.0 20.0 88.0 89.0 6.0 10.0 62.0 99.0 79.0 45.0)
    (3.0 71.0 31.0 74.0 99.0 76.0 93.0 19.0 31.0 61.0)
    (52.0 40.0 11.0 47.0 90.0 11.0 80.0 88.0 45.0 30.0))
NMF(137): (nmf-clustering x 5)
 #(4 1 3 3 2 1 4)
NMF(138): (nmf-clustering x 5 :type :column)
 #(2 0 2 0 0 0 0 1 0 0)
*** rho-k (non-negative-matrix k &key (type :row) (cost-fn :euclidean) (iteration 100) (repeat 100))
- stability of nmf clustering associated with k. we consider k is more stable closer to 1.0.
- return: DOUBLE-FLOAT
- arguments:
   - non-negative-matrix : (SIMPLE-ARRAY DOUBLE-FLOAT (* *))
   - k : size of dimension reduction or number of features
   - type : :row | :column, default is row
   - cost-fn : :euclidean | :kl, default is euclidean
   - iteration : default is 100, internal nmf iteration
   - repeat : default is 100, external nmf iteration to compute rho-k
- comments: Since we need to repeat nmf to take the average and then do hierarchical clustering with ward-method, computing rho-k is slow.
- reference: [[http://www.pnas.org/content/101/12/4164][Metagenes and molecular pattern discovery using matrix factorization]]
*** QUOTE sample usage
NMF(18): (setf matrix (sample-matrix 100 100))
 #2A((37.0 96.0 74.0 31.0 23.0 52.0 77.0 24.0 96.0 68.0 ...)
    (4.0 26.0 41.0 82.0 51.0 10.0 19.0 61.0 48.0 36.0 ...)
    (4.0 91.0 78.0 27.0 72.0 53.0 97.0 7.0 49.0 17.0 ...)
    (45.0 15.0 81.0 65.0 67.0 38.0 66.0 5.0 55.0 88.0 ...)
    (63.0 12.0 56.0 87.0 81.0 1.0 5.0 99.0 88.0 79.0 ...)
    (9.0 26.0 58.0 43.0 38.0 61.0 15.0 47.0 98.0 12.0 ...)
    (56.0 34.0 74.0 84.0 42.0 4.0 1.0 57.0 85.0 65.0 ...)
    (79.0 28.0 9.0 94.0 8.0 72.0 45.0 17.0 85.0 2.0 ...)
    (53.0 41.0 80.0 12.0 69.0 52.0 85.0 94.0 14.0 31.0 ...)
    (20.0 1.0 8.0 40.0 29.0 13.0 75.0 8.0 58.0 26.0 ...)
    ...)
NMF(19): (rho-k matrix 2)
0.9794613282960201
NMF(20): (rho-k matrix 2 :cost-fn :kl)
0.9789550957506326
*** nmf-analysis (non-negative-matrix k &key (cost-fn :euclidean) (iteration 100) (type :row) (results 10))
- print the results of NMF feature extraction
- return: nil
- arguments:
   - non-negative-matrix
   - k : number of features
   - cost-fn : :euclidean | :kl, default is euclidean
   - iteration : default is 100
   - type : :row | :column, default is feature extraction from row data
   - results : print the number of data in descending order, default is 10
*** QUOTE sample usage
NMF(25): (setf x (sample-matrix 100 200))
 #2A((92.0 5.0 77.0 47.0 91.0 25.0 93.0 63.0 48.0 30.0 ...)
    (10.0 2.0 48.0 73.0 90.0 35.0 4.0 19.0 78.0 29.0 ...)
    (38.0 7.0 44.0 61.0 98.0 92.0 11.0 31.0 97.0 80.0 ...)
    (12.0 45.0 53.0 69.0 92.0 95.0 50.0 57.0 57.0 52.0 ...)
    (89.0 33.0 45.0 54.0 43.0 62.0 4.0 92.0 19.0 93.0 ...)
    (38.0 84.0 75.0 71.0 16.0 74.0 34.0 41.0 59.0 83.0 ...)
    (7.0 59.0 45.0 95.0 47.0 55.0 21.0 82.0 55.0 74.0 ...)
    (57.0 41.0 43.0 65.0 56.0 51.0 26.0 26.0 84.0 21.0 ...)
    (44.0 68.0 22.0 83.0 75.0 63.0 98.0 74.0 18.0 79.0 ...)
    (78.0 21.0 71.0 8.0 53.0 88.0 35.0 23.0 20.0 18.0 ...)
    ...)
NMF(26): (nmf-analysis x 3 :type :column :results 5)

Feature 0
81   46.75849601655378
103   45.955361786327046
140   43.68666852948713
64   43.51457629469007
152   42.932921747549514

Feature 1
186   11.79404092624892
138   11.19240951742515
42   10.716884646306237
150   9.93408007033108
98   9.827683668745964

Feature 2
145   8.53136727031378
128   7.427871404203731
131   7.399743366645699
162   7.207875670792123
98   7.097879611292094
NIL
*** nmf-corpus-analysis (corpus-dataset k &key (cost-fn :euclidean) (iteration 100) (results 10))
- print the results of NMF feature extraction from given corpus
- return: nil
- arguments:
   - corpus-dataset (BOW)
   - k : number of features
   - cost-fn : :euclidean | :kl, default is euclidean
   - iteration : default is 100
   - results : print the number of terms or documents in descending order, default is 10
- comments : the form of corpus data is 0th row is term-name vector and 0th column is document-name vector.
*** QUOTE sample usage
NMF(43): (setf corpus-dataset (read-data-from-file "sample/sports-corpus-data" :external-format :utf-8))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: File | 清水 | 試合 | ヤクルト | 鹿島 | 久保田 | ブルペン | 阿部 | 海老原 | 北海道 ...
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN ...
NUMBER OF DIMENSIONS: 1203
DATA POINTS: 100 POINTS
NMF(44): (nmf-corpus-analysis corpus-dataset 4 :results 5)

Feature 0
マラソン     0.06539791632876352
大阪     0.04396451716840554
世界     0.040060656488777956
練習     0.03013540009606857
日本     0.0263706887677491

Feature 1
キャンプ     0.050381707199561754
宮崎     0.04586256603311258
監督     0.04578344596673979
投手     0.03456446647191445
野村     0.031224839643966038

Feature 2
決勝     0.06583621496282896
成年     0.06518764560939831
少年     0.05997504015149991
アイスホッケー     0.05464756076159945
群馬     0.04984371126734561

Feature 3
クラブ     0.03079770863250652
女子     0.024996064747937526
青森     0.023674619657332124
男子     0.023620256997055035
決勝     0.021651435489732713

Feature 0
00267800     4.054754528219457
00267780     3.7131593889464547
00261590     3.682858805780204
00267810     3.45020951637797
00267690     2.3814860805418316

Feature 1
00260660     3.161958458984025
00264500     2.9168932935791005
00261710     2.6708462825315076
00260650     2.467416770070239
00261770     2.4606524064689745

Feature 2
00264720     3.777138076271187
00265130     3.7275902361529445
00264810     3.5318672409737575
00265920     3.067206984954445
00265250     3.0173922648749887

Feature 3
00266020     3.4719778705422577
00266350     3.1108497329849696
00265970     3.066726776112281
00266070     2.609255058301139
00266120     2.4909903804005693
NIL
*** c^3 m-cluster-number (corpus-dataset)
- decide the best cluster number of corpus by cover-coefficient-based concept clustering methodology
- return: DOUBLE-FLOAT
- arguments:
   - corpus-dataset (BOW)
- reference: http://wwwsoc.nii.ac.jp/mslis/pdf/LIS49033.pdf
*** QUOTE sample usage
NMF(48): (setf corpus-dataset (read-data-from-file "sample/sports-corpus-data" :external-format :utf-8))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: File | 清水 | 試合 | ヤクルト | 鹿島 | 久保田 | ブルペン | 阿部 | 海老原 | 北海道 ...
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN ...
NUMBER OF DIMENSIONS: 1203
DATA POINTS: 100 POINTS
NMF(49): (c^3m-cluster-number corpus-dataset)
20.974904271175472
NMF(50): (setf corpus-dataset (read-data-from-file "sample/politics-corpus-data" :external-format :utf-8))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: File | 隠岐 | 定期 | 立場 | 比例 | 入札 | 成長 | 農水 | 秋田 | 教材 ...
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN ...
NUMBER OF DIMENSIONS: 850
DATA POINTS: 80 POINTS
NMF(51): (c^3m-cluster-number corpus-dataset)
15.290476048493785
*** nmf-search (non-negative-matrix row-or-column-number &key type (cost-fn :euclidean) (iteration 100) (results 10))
- find the related or similar data by using nmf
- return: nil
- arguments:
   - non-negative-matrix : (SIMPLE-ARRAY DOUBLE-FLOAT (* * ))
   - row-or-column-number : 
   - type :row | :column : query type
   - cost-fn : :euclidean | :kl, default is euclidean
   - iteration : default is 100
   - results : print the number of row data or column data in descending order, default is 10
- comments : we search the related and/or similar data by using nmf(k=1).
*** QUOTE sample usage
NMF(96): (setf x (sample-matrix 100 200))
 #2A((62.0 91.0 13.0 64.0 59.0 64.0 92.0 48.0 33.0 31.0 ...)
    (0.0 81.0 61.0 38.0 4.0 14.0 97.0 83.0 92.0 20.0 ...)
    (98.0 74.0 45.0 77.0 87.0 67.0 61.0 25.0 89.0 62.0 ...)
    (14.0 3.0 67.0 16.0 41.0 17.0 90.0 13.0 18.0 2.0 ...)
    (47.0 33.0 81.0 14.0 37.0 46.0 61.0 41.0 74.0 92.0 ...)
    (40.0 1.0 93.0 1.0 22.0 95.0 46.0 77.0 68.0 43.0 ...)
    (27.0 38.0 30.0 8.0 91.0 8.0 51.0 22.0 67.0 3.0 ...)
    (50.0 36.0 13.0 73.0 26.0 32.0 13.0 74.0 96.0 28.0 ...)
    (43.0 21.0 27.0 36.0 29.0 39.0 93.0 53.0 12.0 74.0 ...)
    (10.0 78.0 25.0 92.0 83.0 52.0 47.0 20.0 72.0 3.0 ...)
    ...)
NMF(97): (nmf-search x 113 :type :column)

Feature 0
113   145.19488284162378
17   84.73937398353675
123   83.8805446764401
100   83.74400654487428
183   82.11736662225094
91   81.55075159303482
194   81.04143723738916
188   80.93626654118066
97   80.77377247509784
143   79.9072654735812
NIL
*** nmf-corpus-search (corpus-dataset term-or-document-name &key type (iteration 100) (results 10))
- find the related or similar terms or documents by using nmf
- return: nil
- arguments:
   - corpus-dataset (BOW)
   - term-or-document-name
   - type : :term | :document, query type
   - iteration : default is 100
   - results : print the number of terms or documents in descending order, default is 10
- comments : we search the related and/or similar terms or documents by using nmf(k=1).
*** QUOTE sample usage
NMF(52): (setf corpus-dataset (read-data-from-file "sample/sports-corpus-data" :external-format :utf-8))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: File | 清水 | 試合 | ヤクルト | 鹿島 | 久保田 | ブルペン | 阿部 | 海老原 | 北海道 ...
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN ...
NUMBER OF DIMENSIONS: 1203
DATA POINTS: 100 POINTS
NMF(53): (nmf-corpus-search corpus-dataset "西武" :type :term :results 5)

Feature 0
西武     0.5251769235046575
所沢     0.03181077447066429
埼玉     0.031469276621575296
期待     0.029643503937470485
松坂     0.02532560897068374

Feature 0
00261790     8.972318348154714
00266250     4.238044604712796
00261710     1.289125490767428
00261730     0.08947696606550368
00265240     0.06077982768909628
NIL
NMF(54): (nmf-corpus-search corpus-dataset "00267800" :type :document :results 5)

Feature 0
大阪     0.20525379542444078
マラソン     0.17626791348443296
距離     0.10999092287756253
練習     0.09982535243005934
経験     0.08390979988118884

Feature 0
00267800     7.970296782572513
00267780     1.1463577558558922
00267810     0.9796321883720066
00261590     0.9016390011411483
00267690     0.6534929166105935
NIL
NMF(55): (setf corpus-dataset (read-data-from-file "sample/politics-corpus-data" :external-format :utf-8))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: File | 隠岐 | 定期 | 立場 | 比例 | 入札 | 成長 | 農水 | 秋田 | 教材 ...
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN ...
NUMBER OF DIMENSIONS: 850
DATA POINTS: 80 POINTS
NMF(56): (nmf-corpus-search corpus-dataset "クリントン" :type :term :results 5)

Feature 0
クリントン     0.5131911387489791
大統領     0.12539909855726378
アイオワ     0.03805693041474284
米     0.03336496912093245
ヒラリー     0.03046886725695364

Feature 0
00240260     6.164303014225728
00240860     4.927092104170816
00266600     0.4368921996276413
00240820     0.04974743623243792
00251070     0.029176304053375055
NIL
** Spectral-Clustering
   Package for undirected graph clustering
*** spectral-clustering-mcut (m ncls &key (eigen-tolerance 100d0))
- return1: Clustering result as a list of list of nodes
- return2: Status code :success, :questionable, :input-error, or :fatal-error
- arguments:
  - m : <SIMPLE-ARRAY DOUBLE-FLOAT (* *)>, similarity matrix of a graph
  - ncls : <integer>, number of cluster
  - eigen-tolerance : Acceptable error value for eigen computation
*** QUOTE sample usage
 SPECTRAL-CLUSTERING(25): (load "sample/spectral-clustering-sample.cl" :external-format #+allegro :932 #-allegro :sjis)
 SPECTRAL-CLUSTERING(26): *spectral-nodevector*
 #("満足度" "差別" "林" "NPO" "生きがい" "中学" "服" "社会福祉" "市場" "ADL" ...)
 SPECTRAL-CLUSTERING(27): *spectral-w*
 #2A((1.0 0.0 0.0015822785208001733 0.0 0.0 0.0 0.0
      0.0015822785208001733 0.0 0.0015822785208001733 ...)
     (0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
     (0.0015822785208001733 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
     (0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0035273367539048195 0.0 0.0 ...)
     (0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 ...)
     (0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 ...)
     (0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 ...)
     (0.0015822785208001733 0.0 0.0 0.0035273367539048195 0.0 0.0 0.0
      1.0 0.0 0.0 ...)
     (0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 ...)
     (0.0015822785208001733 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 ...)
     ...)
 SPECTRAL-CLUSTERING(28): (spectral-clustering-mcut *spectral-w* 3)
((2 4 6 8 11 12 14 16 18 19 ...) (0 1 3 5 7 9 10 13 15 17 ...)
 (55 73 86 95 111 146 157 257 376))
 :SUCCESS
 SPECTRAL-CLUSTERING(29): (mapcar (lambda (c) (mapcar (lambda (n) (aref *spectral-nodevector* n)) c)) *)
(("林" "生きがい" "服" "市場" "母子" "リサイクル" "腰痛" "手術" "金属" "理論" ...)
 ("満足度" "差別" "NPO" "中学" "社会福祉" "ADL" "癒し" "伊藤" "教材" "ひきこもり" ...)
 ("Method" "system" "language" "study" "education" "Web" "English"
  "japanese" "journal"))
*** Note
References:
 1. 新納浩幸, 「R で学ぶクラスタ解析」, オーム社, 2007.
 2. A Min-max Cut Algorithm for Graph Partitioning and Data Clustering
    Chris H. Q. Ding, Xiaofeng He, Hongyuan Zha, Ming Gu, Horst D. Simon
    First IEEE International Conference on Data Mining (ICDM'01), 2001.
** Optics
   OPTICS -- density-based clustering package 
*** Class
**** optics-output (the result of clustering)
- accessor:
  - ordered-data : points, reachability-distance, core-distance, cluster-id 
  - cluster-info : <list (cluster-id . size)>, ID and the size of elements of each cluster
- note: when cluster-id = -1, it means a noise point.
*** optics (input-path epsilon min-pts r-epsilon target-cols 
                       &key (file-type :sexp) (csv-type-spec '(string double-float double-float)) 
                            (distance :manhattan) (normalize nil) (external-format :default))
- return: optics-output
- arguments:
  - input-path : <string>
  - epsilon : <number> above 0, neighborhood radius
  - min-pts : <integer> above 0, minimum number of data points
  - r-epsilon : <number> above 0 not more than epsilon, threshold for reachability-distance
  - target-cols : <list string>, the names of target columns, each column's type is :numeric
  - file-type : :sexp | :csv
  - csv-type-spec : <list symbol>, type conversion of each column when reading lines from CSV file, e.g. '(string integer double-float double-float)
  - distance : :manhattan | :euclid | :cosine
  - normalize : t | nil
  - external-format	:	<acl-external-format>
*** QUOTE sample usage
OPTICS(10): (optics "sample/syobu.csv" 10 2 10 '("がく長" "がく幅" "花びら長" "花びら幅")
                     :file-type :csv :csv-type-spec '(string integer integer integer integer) 
                     :distance :manhattan :external-format #+allegro :932 #-allegro :sjis)
 #<OPTICS-OUTPUT>
 [ClusterID] SIZE | [-1] 6 | [1] 48 | [2] 96
OPTICS(11): (ordered-data *)
 #(#("ID" "reachability" "core distance" "ClusterID") #(0 10.1 2.0 1)
  #(4 2.0 2.0 1) #(17 2.0 2.0 1) #(27 2.0 2.0 1) #(28 2.0 2.0 1)
  #(39 2.0 2.0 1) #(37 2.0 4.0 1) #(40 2.0 3.0 1) #(7 2.0 2.0 1) ...)
** Association-Rule
   Package for association rule analysis
*** Class
**** assoc-result-dataset (analysis result)
- accessor:
  - rules :       extracted results      <list vector>
  - thresholds :  (support confidence lift conviction)
  - rule-length : maximum length of a rule  <integer>
- note: the vectors of extracted results are rules, they contain the following elements
  - "premise": the premise part of the rule, a list of unit rules
  - "conclusion": the conclusion part of the rule, a list of unit rules
  - "support", "confidence", "lift", "conviction": some helpfulness indices of the rule
  - unit rule (where length is 1), is represented as string "<column name> = <value>".
*** association-analyze (infile outfile target-variables key-variable rule-length
                            &key (support 0) (confident 0) (lift 0) (conviction 0) (external-format :default)
                                 (file-type :sexp) (csv-type-spec '(string double-float))
                                 (algorithm :lcm))
- return: assoc-result-dataset
- arguments:
  - infile : <string>
  - outfile : <string>
  - target-variables : <list string> column names
  - key-variable : <string> column name for determining identities
  - rule-length : <integer> >= 2, maximum length for a rule
  - support : <number> for percentage
  - confident : <number> for percentage
  - lift : <number> beyond 0
  - conviction : <number> beyond 0
  - file-type		:	:sexp | :csv
  - external-format	:	<acl-external-format>
  - csv-type-spec	:	<list symbol>, type conversion of each column when reading lines from CSV file, e.g. '(string integer double-float double-float)
  - algorithm : :apriori | :da | :fp-growth | :eclat | :lcm
*** %association-analyze-apriori (unsp-dataset target-variables key-variable rule-length &key (support 0) (confident 0) (lift 0) (conviction 0))
Association analyze with apriori algorithm.
- return: assoc-result-dataset
- arguments:
  - unsp-dataset: <unspecialized-dataset>
  - target-variables : (list of string) column names
  - key-variable : <string> column name for determining identities
  - rule-length : <integer> >= 2, maximum length for a rule
  - support : <number> for percentage
  - confident : <number> for percentage
  - lift : <number> beyond 0
  - conviction : <number> beyond 0

*** %association-analyze-da-ap-genrule
Association analyze with da-ap-genrule algorithm. This is developer's idea using double-array for calculation.
- return value and arguments are same as %association-analyze-apriori
*** %association-analyze-fp-growth
Association analyze with frequent pattern growth algorithm
- return value and arguments are same as %association-analyze-apriori
*** %association-analyze-eclat
Association analyze with Eclat algorithm
- return value and arguments are same as %association-analyze-apriori
*** %association-analyze-lcm
Association analyze with Linear time Closed itemset Miner(LCM) algorithm
- return value and arguments are same as %association-analyze-apriori
*** QUOTE sample usage
 ASSOC(25): (association-analyze "sample/pos.sexp" "sample/result.sexp"
                                '("商品名") "ID番号" 3 :support 2 :external-format #+allegro :932 #-allegro :sjis)
 #<ASSOC-RESULT-DATASET>
 THRESHOLDS: SUPPORT 2 | CONFIDENCE 0 | LIFT 0 | CONVICTION 0
 RULE-LENGTH: 3
 RESULT: 4532 RULES
 
 ASSOC(6): (setf dataset (read-data-from-file "sample/pos.sexp" :external-format #+allegro :932 #-allegro :sjis))
 #<HJS.LEARN.READ-DATA::UNSPECIALIZED-DATASET>
 DIMENSIONS: ID番号 | 商品名 | 数量 | 金額
 TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
 DATA POINTS: 19929 POINTS
 
 ASSOC(11): (%association-analyze-apriori dataset '("商品名") "ID番号" 3 :support 2)
 #<ASSOC-RESULT-DATASET>
 THRESHOLDS: SUPPORT 2 | CONFIDENCE 0 | LIFT 0 | CONVICTION 0
 RULE-LENGTH: 3
 RESULT: 4532 RULES
** Decision-Tree
   decision tree package 
*** make-decision-tree (unspecialized-dataset objective-variable-name &key (test #'delta-gini) (epsilon 0))
- make decision tree based on CART algorithm
- return: CONS, decision tree
- arguments:
 - unspecialized-dataset
 - objective-variable-name
 - test : delta-gini | delta-entropy , splitting test-function, default is delta-gini
 - epsilon : pre-pruning parameter, default is 0,
- comments : when split, we treat string data as nominal scale and numerical data as ordinal scale.
- reference : Toby Segaran."Programming Collective Intelligence",O'REILLY
*** print-decision-tree (decision-tree &optional (stream t))
- return: NIL
- arguments:
 - decision-tree
 - stream : default is T
*** predict-decision-tree (query-vector unspecialized-dataset decision-tree)
- return: string, prediction
- arguments:
 - query-vector
 - unspecialized-dataset : dataset used to make a decision tree
 - decision-tree
*** QUOTE sample usage
DECISION-TREE(40): (setf *syobu* (read-data-from-file "sample/syobu.csv" :type :csv 
                                                     :csv-type-spec
						    '(string integer integer integer integer)))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: 種類 | がく長 | がく幅 | 花びら長 | 花びら幅
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 150 POINTS
DECISION-TREE(41): (setf *tree* (make-decision-tree *syobu* "種類"))
(((("花びら長" . 30)
   (("花びら幅" . 18) ("花びら幅" . 23) ("花びら幅" . 20) ("花びら幅" . 19) ("花びら幅" . 25) ("花びら幅" . 24) ("花びら幅" . 21)
    ("花びら幅" . 14) ("花びら幅" . 15) ("花びら幅" . 22) ...))
  (("Virginica" . 50) ("Versicolor" . 50) ("Setosa" . 50))
  ((149 148 147 146 145 144 143 142 141 140 ...) (49 48 47 46 45 44 43 42 41 40 ...)))
 (((("花びら幅" . 18) (# # # # # # # # # # ...)) (("Versicolor" . 50) ("Virginica" . 50))
   ((70 100 101 102 103 104 105 107 108 109 ...) (50 51 52 53 54 55 56 57 58 59 ...)))
  (((# #) (# #) (# #)) ((#) (149 148 147 146 145 144 143 142 141 140 ...)) ((# # #) (# #) (# #)))
  (((# #) (# #) (# #)) ((# # #) (# # #) (# #)) ((# # #) (# #) (# #))))
 ((("Setosa" . 50)) (49 48 47 46 45 44 43 42 41 40 ...)))
DECISION-TREE(42): (print-decision-tree *tree*)
[30 <= 花びら長?]((Virginica . 50) (Versicolor . 50) (Setosa . 50))
   Yes->[18 <= 花びら幅?]((Versicolor . 50) (Virginica . 50))
      Yes->[49 <= 花びら長?]((Virginica . 45) (Versicolor . 1))
         Yes->((Virginica . 43))
         No->[31 <= がく幅?]((Versicolor . 1) (Virginica . 2))
            Yes->((Versicolor . 1))
            No->((Virginica . 2))
      No->[50 <= 花びら長?]((Virginica . 5) (Versicolor . 49))
         Yes->[16 <= 花びら幅?]((Versicolor . 2) (Virginica . 4))
            Yes->[53 <= 花びら長?]((Virginica . 1) (Versicolor . 2))
               Yes->((Virginica . 1))
               No->((Versicolor . 2))
            No->((Virginica . 3))
         No->[17 <= 花びら幅?]((Versicolor . 47) (Virginica . 1))
            Yes->((Virginica . 1))
            No->((Versicolor . 47))
   No->((Setosa . 50))
NIL
DECISION-TREE(43): (make-decision-tree *syobu* "種類" :epsilon 0.1)
(((("花びら長" . 30)
   (("花びら幅" . 18) ("花びら幅" . 23) ("花びら幅" . 20) ("花びら幅" . 19) ("花びら幅" . 25) ("花びら幅" . 24) ("花びら幅" . 21)
    ("花びら幅" . 14) ("花びら幅" . 15) ("花びら幅" . 22) ...))
  (("Virginica" . 50) ("Versicolor" . 50) ("Setosa" . 50))
  ((149 148 147 146 145 144 143 142 141 140 ...) (49 48 47 46 45 44 43 42 41 40 ...)))
 (((("花びら幅" . 18) (# # # # # # # # # # ...)) (("Versicolor" . 50) ("Virginica" . 50))
   ((70 100 101 102 103 104 105 107 108 109 ...) (50 51 52 53 54 55 56 57 58 59 ...)))
  ((("Virginica" . 45) ("Versicolor" . 1)) (70 100 101 102 103 104 105 107 108 109 ...))
  ((("Virginica" . 5) ("Versicolor" . 49)) (50 51 52 53 54 55 56 57 58 59 ...)))
 ((("Setosa" . 50)) (49 48 47 46 45 44 43 42 41 40 ...)))
DECISION-TREE(44): (print-decision-tree *)
[30 <= 花びら長?]((Virginica . 50) (Versicolor . 50) (Setosa . 50))
   Yes->[18 <= 花びら幅?]((Versicolor . 50) (Virginica . 50))
      Yes->((Virginica . 45) (Versicolor . 1))
      No->((Virginica . 5) (Versicolor . 49))
   No->((Setosa . 50))
NIL
DECISION-TREE(45): (setf *query* #("?" 53 30 33 10))
 #("?" 53 30 33 10)
DECISION-TREE(46): (predict-decision-tree *query* *syobu* *tree*)
"Versicolor"
*** decision-tree-validation (unspecialized-dataset objective-variable-name decision-tree)
- return: CONS, validation result
- arguments:
 - unspecialized-dataset : dataset for validation
 - objective-variable-name
 - decision-tree
- comments : each element of returning association list represents that ((prediction . answer) . number).
*** QUOTE sample usage
DECISION-TREE(64): (setf *bc-train* (read-data-from-file "sample/bc.train.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 338 POINTS
DECISION-TREE(65): (setf *tree* (make-decision-tree *bc-train* "Class"))
(((("Cell.size" . 4.0)
   (("Bare.nuclei" . 4.0) ("Bare.nuclei" . 1.0) ("Bare.nuclei" . 5.0) ("Bare.nuclei" . 10.0) ("Bare.nuclei" . 2.0) ("Bare.nuclei" . 3.0) ("Bare.nuclei" . 8.0)
    ("Bare.nuclei" . 6.0) ("Bare.nuclei" . 7.0) ("Bare.nuclei" . 9.0) ...))
  (("malignant" . 117) ("benign" . 221)) ((337 334 329 323 317 305 295 292 291 285 ...) (336 335 333 332 331 330 328 327 326 325 ...)))
 (((("Bl.cromatin" . 4.0) (# # # # # # # # # # ...)) (("benign" . 7) ("malignant" . 99))
   ((2 7 10 18 19 25 28 31 34 35 ...) (0 1 20 23 26 54 74 80 119 122 ...)))
  (((# #) (# #) (# #)) ((#) (334 329 323 305 295 292 291 280 275 274 ...)) ((# # #) (# #) (# #)))
  (((# #) (# #) (# #)) ((#) (145 140 133 119 80 54 26 23)) ((# # #) (# #) (# # #))))
 (((("Bare.nuclei" . 6.0) (# # # # # # # # # # ...)) (("malignant" . 18) ("benign" . 214)) ((11 32 60 72 86 128 142 165 170 217) (3 4 5 6 8 9 12 13 14 15 ...)))
  ((("malignant" . 10)) (11 32 60 72 86 128 142 165 170 217)) (((# #) (# #) (# #)) ((#) (131 51 50 27)) ((# # #) (# # #) (# # #)))))
DECISION-TREE(66): (setf *bc-test* (read-data-from-file "sample/bc.test.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 345 POINTS
DECISION-TREE(67): (decision-tree-validation *bc-test* "Class" *tree*)
((("benign" . "malignant") . 4) (("malignant" . "malignant") . 118) (("malignant" . "benign") . 9) (("benign" . "benign") . 214))
*** make-regression-tree (unspecialized-dataset objective-variable-name &key (epsilon 0))
- return: CONS, regression tree
- argumrnts:
  - unspecialized-dataset
  - objective-variable-name
  - epsilon : pre-pruning parameter, default is 0
- comments : we use variance difference as a split criterion.
*** print-regression-tree (regression-tree &optional (stream t))
- return: NIL
- arguments:
 - regression-tree
 - stream : default is T
*** predict-regression-tree (query-vector unspecialized-dataset regression-tree)
- return: real, predictive value
- arguments:
 - query-vector :
 - unspecialized-dataset : used dataset to make the regression tree
 - regression-tree
*** QUOTE sample usage
DECISION-TREE(68): (setf *cars* (read-data-from-file "sample/cars.csv" :type :csv
						      :csv-type-spec '(double-float double-float)))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: speed | distance
TYPES:      UNKNOWN | UNKNOWN
DATA POINTS: 50 POINTS
DECISION-TREE(69): (setf *tree* (make-regression-tree *cars* "distance" :epsilon 35))
(((("speed" . 18.0)
   (("speed" . 25.0) ("speed" . 24.0) ("speed" . 23.0) ("speed" . 22.0) ("speed" . 20.0)
    ("speed" . 19.0) ("speed" . 17.0) ("speed" . 16.0) ("speed" . 15.0) ("speed" . 14.0) ...))
  ((85.0 . 1) (120.0 . 1) (93.0 . 1) (92.0 . 1) (70.0 . 1) (66.0 . 1) (64.0 . 1) (52.0 . 1)
   (48.0 . 1) (68.0 . 1) ...)
  ((49 48 47 46 45 44 43 42 41 40 ...) (30 29 28 27 26 25 24 23 22 21 ...)))
 (((("speed" . 24.0) (# # # # # # # # # # ...))
   ((42.0 . 1) (76.0 . 1) (84.0 . 1) (36.0 . 1) (46.0 . 1) (68.0 . 1) (32.0 . 1) (48.0 . 1)
    (52.0 . 1) (56.0 . 2) ...)
   ((45 46 47 48 49) (31 32 33 34 35 36 37 38 39 40 ...)))
  (((85.0 . 1) (120.0 . 1) (93.0 . 1) (92.0 . 1) (70.0 . 1)) (45 46 47 48 49))
  (((54.0 . 1) (66.0 . 1) (64.0 . 1) (52.0 . 1) (48.0 . 1) (32.0 . 1) (68.0 . 1) (46.0 . 1)
    (36.0 . 1) (84.0 . 1) ...)
   (31 32 33 34 35 36 37 38 39 40 ...)))
 (((("speed" . 13.0) (# # # # # # # # # # ...))
   ((2.0 . 1) (4.0 . 1) (22.0 . 1) (16.0 . 1) (10.0 . 2) (18.0 . 1) (17.0 . 1) (14.0 . 1)
    (24.0 . 1) (28.0 . 2) ...)
   ((15 16 17 18 19 20 21 22 23 24 ...) (0 1 2 3 4 5 6 7 8 9 ...)))
  (((50.0 . 1) (40.0 . 2) (32.0 . 2) (54.0 . 1) (20.0 . 1) (80.0 . 1) (60.0 . 1) (36.0 . 1)
    (46.0 . 1) (34.0 . 2) ...)
   (15 16 17 18 19 20 21 22 23 24 ...))
  (((# #) (# # # # # # # # # # ...) (# #)) ((# # # # # # # #) (14 13 12 11 10 9 8 7 6))
   ((# # # # #) (5 4 3 2 1 0)))))
DECISION-TREE(70): (print-regression-tree *tree*)
[18.0 <= speed?] (mean = 42.98, n = 50)
   Yes->[24.0 <= speed?] (mean = 65.26, n = 19)
      Yes->(mean = 92.00, n = 5)
      No->(mean = 55.71, n = 14)
   No->[13.0 <= speed?] (mean = 29.32, n = 31)
      Yes->(mean = 39.75, n = 16)
      No->[10.0 <= speed?] (mean = 18.20, n = 15)
         Yes->(mean = 23.22, n = 9)
         No->(mean = 10.67, n = 6)
NIL
DECISION-TREE(71): (setf *query* #(24.1 "?"))
 #(24.1 "?")
DECISION-TREE(72): (predict-regression-tree *query* *cars* *tree*)
92.0
*** regression-tree-validation (unspecialized-dataset objective-variable-name regression-tree)
- return: MSE (Mean Squared Error)
- arguments:
 - unspecialized-dataset : for validation
 - objective-variable-name
 - regression-tree
*** QUOTE sample usage
DECISION-TREE(10): (setf *bc-train* (read-data-from-file "sample/bc.train.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 338 POINTS
DECISION-TREE(11): (setf *tree* (make-regression-tree *bc-train* "Cell.size"))
(((("Class" . "benign")
   (("Bare.nuclei" . 4.0) ("Bare.nuclei" . 1.0) ("Bare.nuclei" . 5.0) ("Bare.nuclei" . 10.0) ("Bare.nuclei" . 2.0)
    ("Bare.nuclei" . 3.0) ("Bare.nuclei" . 8.0) ("Bare.nuclei" . 6.0) ("Bare.nuclei" . 7.0) ("Bare.nuclei" . 9.0) ...))
  ((7.0 . 10) (9.0 . 3) (3.0 . 22) (6.0 . 11) (5.0 . 18) (2.0 . 22) (1.0 . 188) (10.0 . 25) (8.0 . 19) (4.0 . 20))
  ((336 335 333 332 331 330 328 327 326 325 ...) (337 334 329 323 305 295 292 291 285 280 ...)))
 (((("Cell.shape" . 7.0) (# # # # # # # # # # ...)) ((8.0 . 1) (7.0 . 1) (4.0 . 5) (2.0 . 15) (3.0 . 12) (1.0 . 187))
   ((1 124) (0 3 4 5 6 8 9 12 13 14 ...)))
  (((# #) (# #) (# #)) ((#) (1)) ((#) (124))) (((# #) (# # # #) (# #)) ((# # #) (# # #) (# # #)) ((# # #) (# #) (# # #))))
 (((("Cell.shape" . 7.0) (# # # # # # # # # # ...))
   ((1.0 . 1) (2.0 . 7) (9.0 . 3) (3.0 . 10) (6.0 . 11) (4.0 . 15) (5.0 . 18) (7.0 . 9) (10.0 . 25) (8.0 . 18))
   ((2 23 52 55 71 76 80 83 84 85 ...) (7 10 11 18 19 20 24 25 26 27 ...)))
  (((# #) (# # # # # #) (# #)) ((# # #) (# # #) (# # #)) ((# # #) (# # #) (# # #)))
  (((# #) (# # # # # # # # #) (# #)) ((# # #) (# #) (# # #)) ((# # #) (# # #) (# # #)))))
DECISION-TREE(12): (setf *bc-test* (read-data-from-file "sample/bc.test.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 345 POINTS
DECISION-TREE(13): (regression-tree-validation *bc-test* "Cell.size" *tree*)
2.356254428341385
** Random-Forest
   random forest package
*** make-random-forest (unspecialized-dataset objective-variable-name &key (test #'delta-gini) (tree-number 500))
- return: (SIMPLE-ARRAY T (* )), random forest consisting of unpruned decision trees
- arguments:
 - unspecialized-dataset
 - objective-variable-name
 - test : delta-gini | delta-entropy , splitting criterion function, default is delta-gini
 - tree-number : the number of decision trees, default is 500
- reference : [[http://www-stat.stanford.edu/~tibs/ElemStatLearn/][Trevor Hastie, Robert Tibshirani and Jerome Friedman. The Elements of Statistical Learning:Data Mining, Inference, and Prediction]]
*** predict-forest (query-vector unspecialized-dataset forest)
- return: string, prediction
- arguments:
 - query-vector
 - unspecialized-dataset : dataset used to make a random forest
 - forest
- comments : make predictions by a majority vote of decision trees in random forest.
*** forest-validation (unspecialized-dataset objective-variable-name forest)
- return: CONS, validation result
- arguments:
 - unspecialized-dataset : dataset for validation
 - objective-variable-name
 - forest
- comments : each element of returning association list represents that ((prediction . answer) . number).
*** importance(forest)
- importance of explanatory variables
- return: NIL
- arguments:
 - forest
*** QUOTE sample usage
RANDOM-FOREST(24): (setf *bc-train* (read-data-from-file "sample/bc.train.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 338 POINTS
RANDOM-FOREST(25): (setf *forest* (make-random-forest *bc-train* "Class"))
 #((((("Normal.nucleoli" . 3.0) NIL) (("benign" . 215) ("malignant" . 123)) ((336 335 328 323 322 319 314 310 304 303 ...) (337 334 333 332 331 330 329 327 326 325 ...)))
   (((# NIL) (# #) (# #)) ((# # #) (# #) (# # #)) ((# # #) (# #) (# #))) (((# NIL) (# #) (# #)) ((#) (27 43 133 150 163 227 329)) ((# # #) (# #) (# # #))))
  (((("Cell.size" . 3.0) NIL) (("benign" . 227) ("malignant" . 111)) ((335 331 329 328 324 322 321 316 313 310 ...) (337 336 334 333 332 330 327 326 325 323 ...)))
   (((# NIL) (# #) (# #)) ((# # #) (# # #) (# # #)) ((#) (39 61 234 255 331))) (((# NIL) (# #) (# #)) ((#) (127 164)) ((#) (1 3 4 5 6 7 10 11 13 15 ...))))
  (((("Normal.nucleoli" . 3.0) NIL) (("malignant" . 118) ("benign" . 220)) ((337 336 334 320 319 310 308 307 306 301 ...) (335 333 332 331 330 329 328 327 326 325 ...)))
   (((# NIL) (# #) (# #)) ((# # #) (# #) (# # #)) ((# # #) (# #) (# #))) (((# NIL) (# #) (# #)) ((#) (8 12 26 91 117 137 180 219 284 298)) ((# # #) (# # #) (# # #))))
  ...)
RANDOM-FOREST(26): (setf *query* #(3.0 1.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 "?"))
 #(3.0 1.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 "?")
RANDOM-FOREST(27): (predict-forest *query* *bc-train* *forest*)
"benign"
RANDOM-FOREST(28): (setf *bc-test* (read-data-from-file "sample/bc.test.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 345 POINTS
RANDOM-FOREST(29): (forest-validation *bc-test* "Class" *forest*)
((("benign" . "malignant") . 3) (("malignant" . "benign") . 7)
 (("malignant" . "malignant") . 119) (("benign" . "benign") . 216))
RANDOM-FOREST(30): (importance *forest*)

Cl.thickness	8.858931522461704
Cell.size	39.27994596828924
Cell.shape	30.884140484077243
Marg.adhesion	6.316809217160305
Epith.c.size	13.456603741915808
Bare.nuclei	15.917177562432531
Bl.cromatin	19.549030429871404
Normal.nucleoli	17.674563815534114
Mitoses	0.5413906648512219
NIL
*** make-regression-forest (unspecialized-dataset objective-variable-name &key (tree-number 500))
- return: (SIMPLE-ARRAY T (* )), regression random forest consisting of unpruned regression trees
- arguments:
 - unspecialized-dataset
 - objective-variable-name
 - tree-number : the number of regression trees, default is 500
*** predict-regression-forest (query-vector unspecialized-dataset regression-forest)
- return: real , predictive value
- arguments:
 - query-vector
 - unspecialized-dataset : dataset used to make a regression forest
 - regression-forest
- comments : make predictions by using the average estimate of each regression tree.
*** regression-forest-validation (unspecialized-dataset objective-variable-name regression-forest)
- return: MSE (Mean Squared Error)
- arguments:
 - unspecialized-dataset : for validation
 - objective-variable-name
 - regression-forest
*** QUOTE sample usage
RANDOM-FOREST(40): (setf *bc-train* (read-data-from-file "sample/bc.train.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 338 POINTS
RANDOM-FOREST(41):(setf *regression-forest* (make-regression-forest *bc-train* "Cell.size"))
 #((((("Class" . "malignant") NIL)
    ((9.0 . 2) (6.0 . 7) (7.0 . 12) (8.0 . 22) (5.0 . 20) (3.0 . 23) (4.0 . 25) (1.0 . 164) (2.0 . 32) (10.0 . 31))
    ((335 327 322 321 320 319 318 314 312 310 ...) (337 336 334 333 332 331 330 329 328 326 ...)))
   (((# NIL) (# # # # # # # # # #) (# #)) ((# # #) (# # #) (# # #)) ((# # #) (# # #) (# # #)))
   (((# NIL) (# # # # #) (# #)) ((# # #) (# #) (# # #)) ((# # #) (# #) (# # #))))
  (((("Cell.shape" . 6.0) NIL)
    ((9.0 . 1) (2.0 . 20) (5.0 . 16) (7.0 . 13) (4.0 . 16) (3.0 . 19) (10.0 . 20) (6.0 . 10) (8.0 . 22) (1.0 . 201))
    ((335 326 325 317 316 314 312 311 307 299 ...) (337 336 334 333 332 331 330 329 328 327 ...)))
   (((# NIL) (# # # # # # #) (# #)) ((# # #) (# # #) (# #)) ((# # #) (# # #) (# # #)))
   (((# NIL) (# # # # # # # # #) (# #)) ((# # #) (# # #) (# # #)) ((# # #) (# # #) (# # #))))
  (((("Epith.c.size" . 3.0) NIL)
    ((9.0 . 4) (2.0 . 16) (4.0 . 23) (7.0 . 9) (6.0 . 5) (3.0 . 24) (5.0 . 16) (10.0 . 17) (8.0 . 21) (1.0 . 203))
    ((334 332 324 320 319 315 314 313 312 308 ...) (337 336 335 333 331 330 329 328 327 326 ...)))
   (((# NIL) (# # # # # # # # # #) (# #)) ((# # #) (# # #) (# # #)) ((# # #) (# # #) (# # #)))
   (((# NIL) (# # # # #) (# #)) ((# # #) (# # #) (# # #)) ((# # #) (# #) (# # #))))
  ...)
RANDOM-FOREST(42): (setf *query* #(5.0 "?" 1.0 1.0 2.0 1.0 3.0 1.0 1.0 "benign"))
 #(5.0 "?" 1.0 1.0 2.0 1.0 3.0 1.0 1.0 "benign")
RANDOM-FOREST(43): (predict-regression-forest *query* *bc-train* *regression-forest*)
1.0172789943526082
RANDOM-FOREST(44): (setf *bc-test* (read-data-from-file "sample/bc.test.csv"
						     :type :csv
						     :csv-type-spec 
						     (append (loop for i below 9 collect 'double-float) '(string))))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 345 POINTS
RANDOM-FOREST(45): (regression-forest-validation *bc-test* "Cell.size" *regression-forest*)
1.6552628917521726
** K-Nearest-Neighbor
*** class
**** k-nn-estimator 
- accessor:
  - vec :           data for learning
  - vec-labels :    explanatories
  - vec-profiles :  type infomation for each explanatories
  - vec-weight :    weight for each explanatories
  - mins :          minimum value for each explanatories
  - maxs :          maximum value for each explanatories
  - target :        objective variable
  - teachers :      values of target
  - k :             value of parameter k
  - distance :      
*** k-nn-analyze (learning-data k target explanatories
                     &key (distance :euclid) target-type
                          use-weight weight-init normalize)
- return: <k-nn-estimator>
- arguments:
  - learning-data : <unspecialized-dataset>
  - k : <integer>
  - target : <string>
  - explanatories : <list string> | :all
  - distance : :euclid | :manhattan | a function object
    - distance now can be a function object, it will be regarded as
      a user-specified distance function.
    - A distance function must accept 3 arguments: vector_1, vector_2
      and profiles. profiles is a list whose elements are
      either :numeric or :delta,
      :numeric indicates the dimension is of numeric values and :delta
      indicates the dimension is of categorical values. It's totally
      fine to ignore profiles if users know exactly what their data is
      about.
  - target-type : :numeric | :category | nil
    - :numeric means regression analysis
    - :category means classification analysis
    - when nil, the target type will be automatically determined by
      the type of data.
  - use-weight : nil | :class | :data
  - weight-init :
    - if use-weight is :class, it's an assoc-list of form ((class-name . weight) ...) 
    - if use-weight is :data, then a vector of weight, a list of
      weight or a column name of input data are allowable. When a
      column name is passed in, the element in the column is treated
      as weight.
  - normalize : t | nil
*** k-nn-estimate (estimator in-data)
- return: <unspecialized-dataset>, estimated result\\
  The column named "estimated-*" (* is the name of target parameter) is appended to 1st column of /in-data/.
- arguments:
  - estimator : <k-nn-estimator> 
  - in-data :  <unspecialized-dataset> data to be estimated.
*** estimator-properties (estimator &key verbose)
- return: <list>, property list
- arguments:
  - estimator : <k-nn-estimator>
  - verbose: nil | t, default is nil
- comment:
  Get k-nn-estimator's properties. If /verbose/ is t, all /accessor/ of k-nn-estimator would be extracted.
*** QUOTE sample usage
 K-NN(12): (setf data-for-learn
             (read-data-from-file "sample/learn.csv" :type :csv 
                                  :csv-type-spec (cons 'string (make-list 105 :initial-element 'double-float))))
 #<HJS.LEARN.READ-DATA::UNSPECIALIZED-DATASET>
 DIMENSIONS: id | A/C CLUTCH | A/C PRESSURE | A/C PRESSURE SENSOR | A/C SWITCH | AF B1 LAMBDA CMD | AF B2 LAMBDA CMD | ...
 TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | ...
 DATA POINTS: 344 POINTS
 
 K-NN(13): (setf estimator
             (k-nn-analyze data-for-learn 2 "id" :all :distance :manhattan :normalize t))
 Number of self-misjudgement : 277
 #<K-NN-ESTIMATOR @ #x2144ae72>
 
 K-NN(8): (estimator-properties estimator :verbose t)
 (:K 2 :TARGET "id" :EXPLANATORIES ("A/C CLUTCH" "A/C PRESSURE" "A/C PRESSURE SENSOR" "A/C SWITCH" "AF B1 LAMBDA CMD" "AF B2 LAMBDA CMD" "AF FB CMD" ...)
  :DISTANCE :MANHATTAN :MINS #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...) ...)

 K-NN(14): (setf data-for-estimate
             (read-data-from-file "sample/estimate.csv" :type :csv
                                  :csv-type-spec (make-list 105 :initial-element 'double-float)))
 #<HJS.LEARN.READ-DATA::UNSPECIALIZED-DATASET>
 DIMENSIONS: A/C CLUTCH | A/C PRESSURE | A/C PRESSURE SENSOR | A/C SWITCH | AF B1 LAMBDA CMD | AF B2 LAMBDA CMD | AF FB CMD | ...
 TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | ...
 DATA POINTS: 23 POINTS
 
 K-NN(15): (k-nn-estimate estimator data-for-estimate)
 #<HJS.LEARN.READ-DATA::UNSPECIALIZED-DATASET>
 DIMENSIONS: estimated-id | A/C CLUTCH | A/C PRESSURE | A/C PRESSURE SENSOR | A/C SWITCH | AF B1 LAMBDA CMD | AF B2 LAMBDA CMD | ...
 TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | ...
 DATA POINTS: 23 POINTS

 K-NN(16): (choice-a-dimension "estimated-id" *)
 #("24" "27" "31" "17" "110" "49" "58" "30" "58" "71" ...)

 ;; Define my distance function
 K-NN(26): (defun my-distance (x-vec y-vec profiles)
              (declare (type (simple-array t (*)) x-vec y-vec)
                       (ignorable profiles))
              (loop for x across x-vec
                  for y across y-vec
                  sum (abs (- x y))))
 MY-DISTANCE

 K-NN(27): (compile *)
 MY-DISTANCE
 NIL
 NIL

 K-NN(28): (k-nn-analyze data-for-learn 2 "id" :all
                         :distance #'my-distance
                         :target-type :category
                         :normalize t)
 Number of self-misjudgement : 277
 #<K-NN-ESTIMATOR @ #x100635d2d2>

*** note
When target, the objective variable's type is string, discriminant
analysis is used, when type is number, regression analysis is used. In
the case of discriminant analysis, the number of self-misjudgement from
self analysis is displayed.
** Support-Vector-Machine
   support vector machine package
*** Class for kernel-fn
**** polynomial-kernel
- reader:
  - dimension
  - homogeneousp
- generator:
  - polynomial-kernel (dimension homogeneousp)
**** radial-kernel
- reader:
  - gamma : <number> above 0
- generator:
  - radial-kernel (gamma)
  - gaussian-kernel (sigma2)
**** sigmoid-kernel
- reader:
  - kappa : <number>
  - shift : <number>
- generator:
  - sigmoid-kernel (kappa shift)
*** QUOTE Parameter
 SVM(18): +linear-kernel+
 #<POLYNOMIAL-KERNEL : D = 1 HOMOGENEOUS>
*** svm (kernel positive-data negative-data &key (iterations 100) (lagrange-iterations 20) (tolerance 1.0d-20))
- return: <Closure>
  - return of <Closure>: two values, (result number)
    - result : t(positive) | nil(negative)
    - number : value of kernel-fn
  - argument of <Closure>: <seq>, estimation target
- arguments:
  - kernel : <kernel-fn>
  - positive-data :  <seq seq>, training data e.g. '((8 8) (8 20) (8 44))
  - negative-data :  <seq seq>, training data
  - iterations : <integer>
  - lagrange-iterations : <integer>
  - tolerance : <number>
*** QUOTE sample usage
SVM(8): (defparameter *positive-set*
  '((8.0 8.0) (8.0 20.0) (8.0 44.0) (8.0 56.0) (12.0 32.0) (16.0 16.0) (16.0 48.0)
    (24.0 20.0) (24.0 32.0) (24.0 44.0) (28.0 8.0) (32.0 52.0) (36.0 16.0)))
SVM(9): (defparameter *negative-set*
  '((36.0 24.0) (36.0 36.0) (44.0 8.0) (44.0 44.0) (44.0 56.0)
    (48.0 16.0) (48.0 28.0) (56.0 8.0) (56.0 44.0) (56.0 52.0)))
SVM(21): (setf linear-fcn
              (svm +linear-kernel+ *positive-set* *negative-set*))
	      #<Closure (:INTERNAL DECISION 0) @ #x212ebfc2>
SVM(22): (funcall linear-fcn (car (last *positive-set*)))
NIL
-46.88582273865575
SVM(23): (setf polynomial-fcn
           (svm (polynomial-kernel 3 nil) *positive-set* *negative-set*))
 #<Closure (:INTERNAL DECISION 0) @ #x20b7c122>
SVM(24): (funcall polynomial-fcn (car (last *positive-set*)))
T
4.849458930036461e+7
SVM(25): (funcall polynomial-fcn '(30.0 20.0))
T
2.3224182219070548e+8
** Support-Vector-Machine (Soft Margin)
*** make-svm-learner (training-vector kernel-function &key c (weight 1.0) file-name external-format cache-size-in-MB)
- return: <Closure>, SVM
- arguments:
 - training-vector : (SIMPLE-ARRAY T (* )) consist of (SIMPLE-ARRAY DOUBLE-FLOAT (* )),
                     data-format : last column is a label (+1.0 or -1.0)
 - kernel-function :<Closure>, kernel function
 - c : penalty parameter of soft margin SVM
 - weight : weight parameter of -1 class, default is 1.0
 - file-name : file-name to save the SVM
 - external-format : character code
 - cache-size-in-MB : Cache size (default 100)
- reference: Working Set Selection Using Second Order Information for Training SVM.
            Chih-Jen Lin.
            Joint work with Rong-En Fan and Pai-Hsuen Chen.
*** load-svm-learner (file-name kernel-function &key external-format)
- return: <Closure>, SVM
- argumtns:
 - file-name : save file name of SVM
 - kernel-function :<Closure>, used kernel function to make the SVM
 - external-format : character code
*** make-linear-kernel ()
- return: <Closure>, linear kernel
*** make-rbf-kernel (&key gamma)
- return: <Closure>, RBF kernel (Gaussian kernel)
- aregumrns:
 - gamma : K(x,y) = exp(-gamma*|| x- y ||^2)
*** make-polynomial-kernel (&key gamma r d)
- return: <Closure>, polynomial kernel
- arguments:
 - gamma, r, d : K(x,y) = (gamma*(x・y)+r)^d
*** svm-validation (svm-learner test-vector)
- return : classification result, accuracy
- arguments:
 - svm-learner : SVM
 - test-vector
*** QUOTE sample usage
SVM.WSS3(44): (read-data-from-file "sample/bc-train-for-svm.csv"
						 :type :csv
						 :csv-type-spec (make-list 10 :initial-element 'double-float))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
NUMBER OF DIMENSIONS: 10
DATA POINTS: 338 POINTS
SVM.WSS3(45): (setf training-vector (dataset-points (pick-and-specialize-data * :data-types (make-list 10 :initial-element :numeric))))
 #(#(5.0 4.0 4.0 5.0 7.0 10.0 3.0 2.0 1.0 1.0) #(6.0 8.0 8.0 1.0 3.0 4.0 3.0 7.0 1.0 1.0) #(8.0 10.0 10.0 8.0 7.0 10.0 9.0 7.0 1.0 -1.0)
  #(2.0 1.0 2.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0) #(4.0 2.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0) #(2.0 1.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0)
  #(1.0 1.0 1.0 1.0 2.0 3.0 3.0 1.0 1.0 1.0) #(7.0 4.0 6.0 4.0 6.0 1.0 4.0 3.0 1.0 -1.0) #(4.0 1.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0)
  #(6.0 1.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0) ...)
SVM.WSS3(46): (read-data-from-file "sample/bc-test-for-svm.csv"
						 :type :csv
						 :csv-type-spec (make-list 10 :initial-element 'double-float))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
NUMBER OF DIMENSIONS: 10
DATA POINTS: 345 POINTS
SVM.WSS3(47): (setf test-vector (dataset-points (pick-and-specialize-data * :data-types (make-list 10 :initial-element :numeric))))
 #(#(5.0 1.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0) #(3.0 1.0 1.0 1.0 2.0 2.0 3.0 1.0 1.0 1.0) #(4.0 1.0 1.0 3.0 2.0 1.0 3.0 1.0 1.0 1.0)
  #(1.0 1.0 1.0 1.0 2.0 10.0 3.0 1.0 1.0 1.0) #(2.0 1.0 1.0 1.0 2.0 1.0 1.0 1.0 5.0 1.0) #(1.0 1.0 1.0 1.0 1.0 1.0 3.0 1.0 1.0 1.0)
  #(5.0 3.0 3.0 3.0 2.0 3.0 4.0 4.0 1.0 -1.0) #(8.0 7.0 5.0 10.0 7.0 9.0 5.0 5.0 4.0 -1.0) #(4.0 1.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0)
  #(10.0 7.0 7.0 6.0 4.0 10.0 4.0 1.0 2.0 -1.0) ...)
SVM.WSS3(49): (setf kernel (make-rbf-kernel :gamma 0.05))
 #<Closure (:INTERNAL MAKE-RBF-KERNEL 0) @ #x101ba6a6f2>
SVM.WSS3(50): (setf svm (make-svm-learner training-vector kernel :c 10 :file-name "svm-sample" :external-format :utf-8))
 #<Closure (:INTERNAL MAKE-DISCRIMINANT-FUNCTION 0) @ #x101bc76a12>
SVM.WSS3(51): (funcall svm (svref test-vector 0))
1.0
SVM.WSS3(52): (svm-validation svm test-vector)
(((1.0 . -1.0) . 2) ((-1.0 . -1.0) . 120) ((-1.0 . 1.0) . 10) ((1.0 . 1.0) . 213))
96.52173913043478
SVM.WSS3(53): (setf svm2 (load-svm-learner "svm-sample" kernel :external-format :utf-8))
 #<Closure (:INTERNAL MAKE-DISCRIMINANT-FUNCTION 0) @ #x101be9db02>
SVM.WSS3(54): (svm-validation svm2 test-vector)
(((1.0 . -1.0) . 2) ((-1.0 . -1.0) . 120) ((-1.0 . 1.0) . 10) ((1.0 . 1.0) . 213))
96.52173913043478
   support-vector-machine (soft margin) package
** Support-Vector-Regression
   support-vector-regression package
*** make-svr-learner (training-vector kernel-function &key c epsilon file-name external-format)
- return: <Closure>, epsilon-SVR
- arguments:
 - training-vector : (SIMPLE-ARRAY T (* )) consist of (SIMPLE-ARRAY DOUBLE-FLOAT (* )),
                     data-format : last column is a target value
 - kernel-function :<Closure>, kernel function
 - c : penalty parameter
 - epsilon : width of epsilon-tube
 - file-name : file-name to save the SVR
 - external-format : character code
- reference: A Study on SMO-type Decomposition Methods for Support Vector Machines.
            Pai-Hsuen Chen, Rong-En Fan, and Chih-Jen Lin
*** load-svr-learner (file-name kernel-function &key external-format)
- return: <Closure>, epsilon-SVR
- argumetns:
 - file-name : save file name of SVR
 - kernel-function :<Closure>, used kernel function to make the SVR
 - external-format : character code
*** svr-validation (svr-learner test-vector)
- return : MSE (Mean Squared Error)
- arguments:
 - svr-learner
 - test-vector
*** QUOTE sample usage
SVR(251): (read-data-from-file "sample/bc-train-for-svm.csv"
                                                 :type :csv
                                                 :csv-type-spec (make-list 10 :initial-element 'double-float))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
NUMBER OF DIMENSIONS: 10
DATA POINTS: 338 POINTS
SVR(252): (pick-and-specialize-data * :data-types (make-list 10 :initial-element :numeric))
 #<NUMERIC-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
NUMBER OF DIMENSIONS: 10
NUMERIC DATA POINTS: 338 POINTS
SVR(253): (setf training-vector (choice-dimensions '("Cl.thickness" "Cell.shape" "Marg.adhesion" "Epith.c.size" "Bare.nuclei" 
					   "Bl.cromatin" "Normal.nucleoli" "Mitoses" "Class" "Cell.size") *))
 #(#(5.0 4.0 5.0 7.0 10.0 3.0 2.0 1.0 1.0 4.0) #(6.0 8.0 1.0 3.0 4.0 3.0 7.0 1.0 1.0 8.0)
  #(8.0 10.0 8.0 7.0 10.0 9.0 7.0 1.0 -1.0 10.0) #(2.0 2.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0 1.0)
  #(4.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0 2.0) #(2.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0 1.0)
  #(1.0 1.0 1.0 2.0 3.0 3.0 1.0 1.0 1.0 1.0) #(7.0 6.0 4.0 6.0 1.0 4.0 3.0 1.0 -1.0 4.0)
  #(4.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0 1.0) #(6.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0 1.0) ...)
SVR(254): (read-data-from-file "sample/bc-test-for-svm.csv"
                                                 :type :csv
                                                 :csv-type-spec (make-list 10 :initial-element 'double-float))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
NUMBER OF DIMENSIONS: 10
DATA POINTS: 345 POINTS
SVR(255): (pick-and-specialize-data * :data-types (make-list 10 :initial-element :numeric))
 #<NUMERIC-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
NUMBER OF DIMENSIONS: 10
NUMERIC DATA POINTS: 345 POINTS
SVR(256): (setf test-vector (choice-dimensions '("Cl.thickness" "Cell.shape" "Marg.adhesion" "Epith.c.size" "Bare.nuclei" 
					   "Bl.cromatin" "Normal.nucleoli" "Mitoses" "Class" "Cell.size") *))
 #(#(5.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0 1.0) #(3.0 1.0 1.0 2.0 2.0 3.0 1.0 1.0 1.0 1.0)
  #(4.0 1.0 3.0 2.0 1.0 3.0 1.0 1.0 1.0 1.0) #(1.0 1.0 1.0 2.0 10.0 3.0 1.0 1.0 1.0 1.0)
  #(2.0 1.0 1.0 2.0 1.0 1.0 1.0 5.0 1.0 1.0) #(1.0 1.0 1.0 1.0 1.0 3.0 1.0 1.0 1.0 1.0)
  #(5.0 3.0 3.0 2.0 3.0 4.0 4.0 1.0 -1.0 3.0) #(8.0 5.0 10.0 7.0 9.0 5.0 5.0 4.0 -1.0 7.0)
  #(4.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0 1.0) #(10.0 7.0 6.0 4.0 10.0 4.0 1.0 2.0 -1.0 7.0) ...)
SVR(257): (setf kernel (make-rbf-kernel :gamma 0.001))
 #<Closure (:INTERNAL MAKE-RBF-KERNEL 0) @ #x100dd4de92>
SVR(258): (setf svr (make-svr-learner training-vector kernel :c 10 :epsilon 0.01 :file-name "sample-svr" :external-format :utf-8))
 #<Closure (:INTERNAL MAKE-REGRESSION-FUNCTION 0) @ #x1018e12f72>
SVR(259): (funcall svr (svref test-vector 0))
1.0226811804369387
SVR(260): (svr-validation svr test-vector)
1.4198010745021363
SVR(261): (setf svr2 (load-svr-learner "sample-svr" kernel :external-format :utf-8))
 #<Closure (:INTERNAL MAKE-REGRESSION-FUNCTION 0) @ #x1019594222>
SVR(262): (svr-validation svr2 test-vector)
1.4198010745021363
** One-Class-SVM
   one-class-SVM package (unsupervised, outlier detection)
*** one-class-svm (data-vector &key nu gamma)
- return: <Closure>, one-class-SVM
- arguments:
 - data-vector : (SIMPLE-ARRAY T (* )) consist of (SIMPLE-ARRAY DOUBLE-FLOAT (* ))
 - nu :　0 <= nu <= 1, parameter
 - gamma : gamma of RBF-kernel
*** QUOTE sample usage
ONE-CLASS-SVM(15): (read-data-from-file "sample/bc-train-for-svm.csv"
                                                 :type :csv
                                                 :csv-type-spec (make-list 10 :initial-element 'double-float))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: Cl.thickness | Cell.size | Cell.shape | Marg.adhesion | Epith.c.size | Bare.nuclei | Bl.cromatin | Normal.nucleoli | Mitoses | Class
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN
NUMBER OF DIMENSIONS: 10
DATA POINTS: 338 POINTS
ONE-CLASS-SVM(16): (setf data-vector (dataset-points (pick-and-specialize-data * :data-types (make-list 10 :initial-element :numeric))))
 #(#(5.0 4.0 4.0 5.0 7.0 10.0 3.0 2.0 1.0 1.0) #(6.0 8.0 8.0 1.0 3.0 4.0 3.0 7.0 1.0 1.0)
  #(8.0 10.0 10.0 8.0 7.0 10.0 9.0 7.0 1.0 -1.0) #(2.0 1.0 2.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0)
  #(4.0 2.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0) #(2.0 1.0 1.0 1.0 2.0 1.0 2.0 1.0 1.0 1.0)
  #(1.0 1.0 1.0 1.0 2.0 3.0 3.0 1.0 1.0 1.0) #(7.0 4.0 6.0 4.0 6.0 1.0 4.0 3.0 1.0 -1.0)
  #(4.0 1.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0) #(6.0 1.0 1.0 1.0 2.0 1.0 3.0 1.0 1.0 1.0) ...)
ONE-CLASS-SVM(17): (setf one-class-svm (one-class-svm data-vector :nu 0.01 :gamma 0.005))
 #<Closure (:INTERNAL MAKE-DISCRIMINANT-FUNCTION 0) @ #x1003db0772>
ONE-CLASS-SVM(18): (funcall one-class-svm (svref data-vector 0))
1.0 ;;normal value
ONE-CLASS-SVM(19): (loop
		     for data across data-vector
		     if (= -1.0 (funcall one-class-svm data))
		     do (print data))
;;outliers
 #(10.0 4.0 2.0 1.0 3.0 2.0 4.0 3.0 10.0 -1.0) 
 #(6.0 10.0 2.0 8.0 10.0 2.0 7.0 8.0 10.0 -1.0) 
 #(5.0 10.0 6.0 1.0 10.0 4.0 4.0 10.0 10.0 -1.0) 
 #(1.0 1.0 1.0 1.0 10.0 1.0 1.0 1.0 1.0 1.0) 
 #(10.0 8.0 10.0 10.0 6.0 1.0 3.0 1.0 10.0 -1.0) 
 #(10.0 10.0 10.0 3.0 10.0 10.0 9.0 10.0 1.0 -1.0) 
 #(9.0 1.0 2.0 6.0 4.0 10.0 7.0 7.0 2.0 -1.0) 
 #(2.0 7.0 10.0 10.0 7.0 10.0 4.0 9.0 4.0 -1.0) 
 #(3.0 10.0 3.0 10.0 6.0 10.0 5.0 1.0 4.0 -1.0) 
 #(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0) 
 #(10.0 8.0 10.0 1.0 3.0 10.0 5.0 1.0 1.0 -1.0) 
 #(10.0 2.0 2.0 1.0 2.0 6.0 1.0 1.0 2.0 -1.0) 
 #(5.0 7.0 10.0 10.0 5.0 10.0 10.0 10.0 1.0 -1.0) 
 NIL
** Naive-Bayes
   Naive-Bayes package (Multivariate Bernoulli and Multinomial Naive Bayes) 
*** mbnb-learn (training-vector &key (alpha 1.0d0)
- return List:(p-wc classes):array of conditional probabilities and class labels
- arguments
 - training-vector:bag of words matrix (rows = documents, columns = words) whose class label locates the final column
 - alpha :smoothing parameter, its default value is 1.0
*** make-mbnb-learner (p-wc classes)
- return Closure (learner)
- arguments
 - p-wc:array of conditional probabilities
 - classes:class labels
*** mnb-learn (training-vector &key (alpha 1.0d0)
- return List:(q-wc classes):array of conditional probabilities and class labels
- arguments
 - training-vector::bag of words matrix (rows = documents, columns = words) whose class label locates the final column
 - alpha:smoothing parameter, its default value is 1.0
*** make-mnb-learner (q-wc classes):array of conditional probabilities and class labels
- return Closure (learner)
- arguments
 - q-wc:array of conditional probabilities
 - classes:class labels
*** QUOTE sample usage
NBAYES(15): (setf bow-train (dataset-points (read-data-from-file "~/old-tool/dump-train-csv/bow-train.csv"
						     :type :csv :csv-type-spec `(,@(loop repeat 928 collect 'double-float) string))))
 #(#(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 1.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 1.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 1.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 1.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...) ...)
NBAYES(16): (setf bow-test (dataset-points (read-data-from-file "~/old-tool/dump-train-csv/bow-test.csv"
						    :type :csv :csv-type-spec `(,@(loop repeat 928 collect 'double-float) string))))
 #(#(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 1.0 0.0 0.0 0.0 6.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 2.0 0.0 0.0 0.0 ...)
  #(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ...) ...)
NBAYES(17): (mbnb-learn bow-train)
(#(#(0.02702702702702703 0.02702702702702703 0.40540540540540543 0.40540540540540543 0.02702702702702703 0.02702702702702703 0.08108108108108109 0.02702702702702703
     0.02702702702702703 0.02702702702702703 ...)
   #(0.0196078431372549 0.0196078431372549 0.0392156862745098 0.0196078431372549 0.0196078431372549 0.0196078431372549 0.2549019607843137 0.0392156862745098 0.0196078431372549
     0.0196078431372549 ...))
 ("cobol" "lisp"))
NBAYES(18): (setf mbnb-learner (apply #'make-mbnb-learner *))
 #<Closure (:INTERNAL MAKE-MBNB-LEARNER 0) @ #x1001356d8d2>
NBAYES(19): (learner-validation mbnb-learner bow-test)
((("cobol" . "lisp") . 1) (("lisp" . "lisp") . 60) (("cobol" . "cobol") . 9))
98.57142857142858
** Self-Organizing-Map
   package for self-organizing map
*** do-som-by-filename (in-data-file s-topol s-neigh xdim ydim randomize length ialpha iradius num-labels directory &key debug)
- return: nil
- arguments:
  - in-data-file : <string>, input data
  - s-topol : "hexa" | "rect", topology type
  - s-neigh : "bubble" | "gaussian", neighborhood type
  - xdim : <integer>, x size of output map
  - ydim : <integer>, y size of output map
  - randomize : random seed for initialization
  ;; training parameters 
  - length : how many times train for path1
  - ialpha : learning rate for path1 x100
  - iradius : learning radius for path1 x100
  ;; visualization parameters
  - num-labels : number of labels on same map point 
  ;; output ps directory
  - directory : <string>
  - debug : t | nil
*** QUOTE sample usage
SOM(27): (do-som-by-filename "som/animal.dat" "hexa" "gaussian"
                             24 16 123 10000 5 2400 10
                             '(:absolute #+unix "tmp" #+mswindows "temp"))
in-data-file [som/animal.dat]
s-topol[hexa] s-neigh[gaussian] xdim[24] ydim[16] nrand[123]
num-label[10]
step 1 : initialization 
step 2 : learning 
step 3 : calibration 
step 4 : labeling 
step 5 : making sammon map
384 entries in codebook
xma-xmi 3.074987831736982 yma-ymi 2.129596273225805
#P"/tmp/out"
#P"/tmp/tempa175816032024.ps"
** Time-Series-Read-Data
   package for reading time series data
*** Structure
**** ts-point (time series data points)
- accessor
  - ts-p-time : n-th period of the data point, integer larger than 1.
  - ts-p-freq : n-th of the period of the data point, integer larget than 1
  - ts-p-label : name of the data point. e.g. "2009/jan/5th"
  - ts-p-pos : coordinate of the data point
*** Class
**** time-series-dataset (time series data)
- accessor
  - ts-points : vector of ts-point
  - ts-freq : number of observed values per a cycle
  - ts-start : time for the first observed value, ts-point is represented as list of time and freq. Please refer to the sample usage.
  - ts-end : time for the last observed value, the form is same as ts-start.
*** time-series-data ((d unspecialized-dataset) &key (start 1) end (frequency 1) (range :all) except time-label)
- return: <time-series-dataset>
- arguments:
  - d          : <unspecialized-dataset>
  - start      : <list integer integer> | integer, specify the start time, integer larger than 1 or a list of integer of such kind. e.g. (1861 3)
  - end        : <list integer integer> | integer, specify the end time, format same as start. When unspecified, all the lines will be read in.
  - frequency  : integer >= 1, specify the frequency 
  - range      : :all | <list integer>, indices of columns used in the result, start from 0, e.g. '(0 1 3 4)
  - except     : <list integer>, the opposite of :range, indices of columns which will be excluded from the result, start from 0. e.g. '(2)
  - time-label : integer, index of column which represents the labels of time series data points, no labels when not specified.
*** ts-cleaning ((d time-series-dataset) &key interp-types-alist outlier-types-alist outlier-values-alist)
- return: <time-series-dataset>
- arguments:
  - d : <time-series-dataset>
  - interp-types-alist   : a-list (key: column name, datum: interpolation(:zero :min :max :mean :median :mode :spline)) | nil\\
  - outlier-types-alist  : a-list (key: column name, datum: outlier-verification(:std-dev :mean-dev :user :smirnov-grubbs :freq)) | nil\\
  - outlier-values-alist : a-list (key: outlier-verification datum: the value according to outlier-verification) | nil
- comment:
  Same as /dataset-cleaning/ in read-data package.
*** QUOTE sample usage
 TS-READ-DATA(26): (setf d (read-data-from-file "sample/msi-access-stat/access-log-stat-0.sexp"))
 #<UNSPECIALIZED-DATASET>
 DIMENSIONS: date/time | hits
 TYPES:      UNKNOWN | UNKNOWN
 DATA POINTS: 9068 POINTS
 TS-READ-DATA(27): (setf msi-access (time-series-data d :range '(1) :time-label 0
                                    :frequency 24 :start '(18 3)))
 #<TIME-SERIES-DATASET>
 DIMENSIONS: hits
 TYPES:      NUMERIC
 FREQUENCY:  24
 START:      (18 3)
 END:        (25 2)
 POINTS:     168
 TIME-LABEL: date/time
 TS-READ-DATA(28): (setf msi-access (time-series-data d :range '(1) :time-label 0
                                    :frequency 24 :start '(18 3) :end '(18 24)))
 #<TIME-SERIES-DATASET>
 DIMENSIONS: hits
 TYPES:      NUMERIC
 FREQUENCY:  24
 START:      (18 3)
 END:        (18 24)
 POINTS:     22
 TIME-LABEL: date/time
 TS-READ-DATA(29): (setf msi-access (time-series-data d :range '(1) :time-label 0
                                    :frequency 3))
 #<TIME-SERIES-DATASET>
 DIMENSIONS: hits
 TYPES:      NUMERIC
 FREQUENCY:  3
 START:      (1 1)
 END:        (56 3)
 POINTS:     168
 TIME-LABEL: date/time
 TS-READ-DATA(29): (ts-points msi-access)
 #(#S(TS-POINT :TIME 1 :FREQ 1 :LABEL "12/May/2008 03:00-03:59" :POS #(210.0))
   #S(TS-POINT :TIME 1 :FREQ 2 :LABEL "12/May/2008 04:00-04:59" :POS #(265.0))
   #S(TS-POINT :TIME 1 :FREQ 3 :LABEL "12/May/2008 05:00-05:59" :POS #(219.0))
   #S(TS-POINT :TIME 2 :FREQ 1 :LABEL "12/May/2008 06:00-06:59" :POS #(284.0))
   #S(TS-POINT :TIME 2 :FREQ 2 :LABEL "12/May/2008 07:00-07:59" :POS #(287.0))
   #S(TS-POINT :TIME 2 :FREQ 3 :LABEL "12/May/2008 08:00-08:59" :POS #(829.0))
   #S(TS-POINT :TIME 3 :FREQ 1 :LABEL "12/May/2008 09:00-09:59" :POS #(1039.0))
   #S(TS-POINT :TIME 3 :FREQ 2 :LABEL "12/May/2008 10:00-10:59" :POS #(1765.0))
   #S(TS-POINT :TIME 3 :FREQ 3 :LABEL "12/May/2008 11:00-11:59" :POS #(2021.0))
   #S(TS-POINT :TIME 4 :FREQ 1 :LABEL "12/May/2008 12:00-12:59" :POS #(1340.0)) ...)
** Time-Series-Statistics
Package for statistic utils for /time-series-dataset/.
*** diff ((d time-series-dataset) &key (lag 1) (differences 1))
- return: <time-series-dataset>
- arguments:
  - d : <time-series-dataset>
  - lag : <integer>, degree of lag
  - differences : <integer> >= 1, number of difference
- comments:
  Calculate the Difference.
  e.g. Suppose the trend of /time-series-dataset/ is linear. It will be eliminated by /differences/ = 1.
*** ts-ratio ((d time-series-dataset) &key (lag 1))
- return: <time-series-dataset>
- arguments:
  - d : <time-series-dataset>
  - lag : <integer>, degree of lag
- comments:
  Calculate the ratio of period-on-period increase/decrease with the assumption that /lag/ is the frequency for /d/.
*** ts-log ((d time-series-dataset) &key (logit-transform nil))
- return: <time-series-dataset>
- arguments:
  - d : <time-series-dataset>
  - logit-transform : t | nil, logit transformation is effective for (0, 1) values ts data
*** ts-min, ts-max, ts-mean, ts-median
- argument: <time-series-dataset>
*** ts-covariance, ts-correlation ((d time-series-dataset) &key (k 0))
- return: <matrix>, auto-covariance or auto-correlation matrix with lag k
- arguments:
  - d : <time-series-dataset>
  - k : <positive integer>, degree of lag
*** acf ((d time-series-dataset) &key (type :correlation) (plot nil) (print t) max-k)
- return: nil | <list>
- arguments:
  - d     : <time-series-dataset>
  - type  : :covariance | :correlation
  - max-k : <positive integer>
  - plot  : nil | t, when plot is t, result will be plotted by R.
  - print : nil | t, when print is t, result will be printed.
*** ccf (d1 d2 &key (type :correlation) (plot t) (print nil) max-k)
- return: nil | <list>
- arguments:
  - d1, d2 : <time-series-dataset>, one dimensional
  - type  : :covariance | :correlation
  - max-k : <positive integer>
  - plot  : nil | t, when plot is t, result picture will be plotted by R.
  - print : nil | t, when print is t, result will be printed.  
*** ma ((d time-series-dataset) &key (k 5) weight)
- return: <time-series-dataset>
- arguments:
  - d : <time-series-dataset>, one dimensional
  - k : <positive integer>, range of calculation for average
  - weight : nil | <list>, when weight is nil, it will be all same weight.
*** periodgram ((d time-series-dataset) &key (print t) (plot nil) (log t) (smoothing :raw) step)
- return: nil | <list>
- arguments:
  - d     : <time-series-dataset>
  - plot  : nil | t, when plot is t, result picture will be plotted by R.
  - print : nil | t, when print is t, result will be printed.  
  - log   : nil | t, when log is t, the value of P(f) will be logarized.
  - smoothing : :raw | :mean | :hanning | :hamming, the way of smoothing
  - step  : nil | <positive integer>, parameter for smoothing :mean
- comments:
  Because of the algorithm of FFT,
  only the power of the frequency which has cycle m / 2^n (m,n : natural number) is obtained.
*** QUOTE sample usage
 TS-STAT(90): (setq ukgas (time-series-data (read-data-from-file "sample/UKgas.sexp") :range '(1) :time-label 0)
                    useco (time-series-data (read-data-from-file "sample/USeconomic.sexp")))

 TS-STAT(91): (acf useco)
 log(M1)
 log(M1) log(GNP) rs rl
 1.000 (0.000) 0.573 (0.000) 0.090 (0.000) 0.167 (0.000)
 0.949 (1.000) 0.540 (-1.000) 0.113 (-1.000) 0.154 (-1.000)
 0.884 (2.000) 0.503 (-2.000) 0.123 (-2.000) 0.141 (-2.000)
 0.807 (3.000) 0.463 (-3.000) 0.132 (-3.000) 0.128 (-3.000)
 0.725 (4.000) 0.422 (-4.000) 0.139 (-4.000) 0.117 (-4.000)
 ...
 TS-STAT(92): (ccf (sub-ts useco :range '(0)) (sub-ts useco :range '(1)))
 log(M1) : log(GNP)
 0.195 (-21.000)
 0.190 (-20.000)
 0.190 (-19.000)
 0.193 (-18.000)
 0.198 (-17.000)
 0.205 (-16.000)
 ...
 TS-STAT(95): (periodgram ukgas)
 Frequency | log P(f)
 0.00781250 | 14.38906769
 0.01562500 | 13.00093289
 0.02343750 | 12.34768838
 0.03125000 | 11.73668589
 0.03906250 | 11.20979558
 0.04687500 | 10.62278452
 ...
** Time-Series-State-Space-Model
Package for state space model.
This is useful for representing various time series model.
*** Class
**** state-space-model
- state space model
- accessors:
  - ts-data : observed time series data
**** gaussian-stsp-model
- gaussian state space model
- parent: state-space-model
**** trend-model
- parent: gaussian-stsp-model
- accessors:
  - diff-k : Degree for trend model
  - tau^2  : Variance for trend model
  - aic : Akaike's Information Criterion
**** seasonal-model
- parent: gaussian-stsp-model
- accessors
  - s-deg  : Degree for seasonal model
  - s-freq : Frequency for seasonal model
  - tau^2  : Variance for seasonal model
**** seasonal-adjustment-model
Standard seasonal adjustment model ( Trend + Seasonal )
- parent: gaussian-stsp-model
- accessors
  - trend-model
  - seasonal-model
*** trend ((d time-series-dataset) &key (k 1) (t^2 0d0) (opt-t^2 nil) (delta 0.1d0) (search-width 10))
- return: <trend-model>
- arguments:
  - d            : <time-series-dataset>
  - k            : <positive-integer>
  - t^2          : <positive-number>
  - opt-t^2      : nil | t
  - delta        : <positive-number>
  - search-width : <positive-integer>
- comments:
  - In general, degree for model /k/ is 1 or 2. When /k/ = 1, assume the trend is locally fixed.
    When /k/ = 2, assume the trend is locally linear.
  - When /opt-t^2/ is t, /t^2/ is automatically estimated according to /delta/ and /search-width/.\\
    In the range /t^2/ - /delta/ * /search-width/ <= /t^2/ + /delta/ * /search-width/, minimize AIC of the model.\\
    And /delta/ decides the step for /t^2/.
*** seasonal-adj ((d time-series-dataset) &key (tr-k 1) (tr-t^2 0d0) (s-deg 1) s-freq (s-t^2 0d0) (s^2 1d0))
- return: <seasonal-adjustment-model>
- arguments:
  - d            : <time-series-dataset>, one dimensional time-series-dataset
  - tr-k         : <positive-integer>, Degree for trend model
  - tr-t^2       : <positive-number>, Variance for trend model
  - s-deg        : <positive-integer>, Degree for seasonal model
  - s-freq       : <positive-integer>, Frequency, If if's not specified, frequency of /d/ is applied.
  - s-t^2        : <positive-number>, Variance for seasonal model
  - s^2          : <positive-number>, Variance for observation model
- comments:
  - Seasonal adjustment model is the model which decompose /d/ into trend model and seasonal model.
  - In general, /s-deg/ should be degree 1.
  - /s-freq/ must be more than 2.
*** predict ((model gaussian-stsp-model) &key (n-ahead 0))
- return: (values <time-series-dataset> <time-series-dataset>)
  - first value is a prediction by model, second is a standard error of the model.
- arguments:
  - n-ahead : <non-negative-integer>
- comments:
  - In the case of trend model, the trend of last point of observed data continue to future.
*** QUOTE sample usage
 TS-STSP(123): (defparameter tokyo
                  (time-series-data
                   (read-data-from-file "sample/tokyo-temperature.sexp")))
 TOKYO

 TS-STSP(7): (trend tokyo :k 2 :opt-t^2 t)
 #<TREND-MODEL>
 K:   2
 T^2: 0.1
 AIC: 2395.073754930766

 TS-STSP(8): (predict * :n-ahead 10)
 #<TIME-SERIES-DATASET>
 DIMENSIONS: trend
 TYPES:      NUMERIC
 FREQUENCY:  1
 START:      (1 1)
 END:        (458 1)
 POINTS:     458
 #<TIME-SERIES-DATASET>
 DIMENSIONS: standard error
 TYPES:      NUMERIC
 FREQUENCY:  1
 START:      (1 1)
 END:        (458 1)
 POINTS:     458
** Time-Series-Auto-Regression
Package for AutoRegression model
*** Class
**** ar-model
- parent: gaussian-stsp-model
- accessors:
  - ar-coefficients : AR parameters
  - sigma^2 : Variance for AR model
  - aic : AIC for AR model
  - ar-method : Method of constructing AR model
*** ar ((d time-series-dataset) &key order-max (method :burg) (aic t) (demean t))
- return: <ar-model>
- arguments:
  - d         : <time-series-dataset>
  - order-max : <positive integer>
  - method    : :yule-walker | :burg
  - aic       : nil | t
  - demean    : nil | t
- comments:
  when /aic/ is t, minimize aic to choose the order (max is /order-max/) of model.
  when /aic/ is nil, /order-max/ is the order of model.
*** predict ((model ar-model) &key (n-ahead 0))
- return: (values <time-series-dataset> <time-series-dataset>)
  - first value is a prediction by model, second is a standard error of the model.
- arguments:
  - model : <ar-model>
  - n-ahead : <non-negative integer>
*** ar-prediction ((d time-series-dataset) &key (method :yule-walker) (aic t) order-max n-learning (n-ahead 0) (demean t) target-col)
- return: (values <time-series-dataset> <ar-model> <time-series-dataset>)
- arguments:
  - d : <time-series-dataset>
  - order-max : <positive integer>
  - method    : :yule-walker | :burg
  - aic       : nil | t
  - demean    : nil | t
  - n-ahead   : <non-negative integer>
  - n-learning : nil | <positive integer>, number of points for learning
  - target-col : nil | <string>, name of target parameter
*** parcor-filtering ((ts time-series-dataset) &key (divide-length 15) (parcor-order 1) (n-ahead 10) ppm-fname)
- return: <time-series-dataset>, values for parcor picture
- arguments:
  - ts : <time-series-dataset>
  - divide-length : <positive integer>
  - parcor-order : <positive integer> below divide-length
  - n-ahead : <non-negative integer>, number for ar-prediction on parcor picture
  - ppm-fname : <string> | <pathname>, name for parcor picture
- comments:
  Refer section 3.2.1 of paper http://www.neurosci.aist.go.jp/~kurita/lecture/statimage.pdf \\
  Divide time series data by /divide-length/. And make 'parcor picture' for each range.
*** QUOTE sample usage
 TS-AR(128): (defparameter ukgas 
                (time-series-data
                 (read-data-from-file "sample/UKgas.sexp")
                 :range '(1) :time-label 0
                 :start 1960 :frequency 4))

 TS-AR(14): (setq model (ar ukgas))
 #<AR-MODEL>
 method: BURG
 Coefficients:
 a1 0.17438913366790465
 a2 -0.20966263354643136
 a3 0.459202505071864
 a4 1.0144694385486095
 a5 0.2871426375860843
 a6 -0.09273505423571009
 a7 -0.13087574744684466
 a8 -0.34467398543738703
 a9 -0.1765456124104221
 Order selected 9, sigma^2 estimated as 1231.505368951319

 TS-AR(15): (predict model :n-ahead 12)
 #<TIME-SERIES-DATASET>
 DIMENSIONS: UKgas
 TYPES:      NUMERIC
 FREQUENCY:  4
 START:      (1962 2)
 END:        (1989 4)
 POINTS:     111
 TIME-LABEL: year season
 #<TIME-SERIES-DATASET>
 DIMENSIONS: standard error
 TYPES:      NUMERIC
 FREQUENCY:  4
 START:      (1962 2)
 END:        (1989 4)
 POINTS:     111
 TIME-LABEL: year season

 TS-AR(16): (ar-prediction ukgas :method :burg :n-learning 80 :n-ahead 12)
 #<TIME-SERIES-DATASET>
 DIMENSIONS: UKgas
 TYPES:      NUMERIC
 FREQUENCY:  4
 START:      (1962 2)
 END:        (1983 1)
 POINTS:     84
 TIME-LABEL: year season
 #<AR-MODEL>
 method: BURG
 Coefficients:
 a1 0.03855018085036885
 a2 -0.16131564249720193
 a3 0.43498481388230215
 a4 1.050917089787715
 a5 0.5797305440261313
 a6 -0.13363258905263287
 a7 -0.16163235104434967
 a8 -0.3748978324320104
 a9 -0.3151508389321235
 Order selected 9, sigma^2 estimated as 741.5626361893945
 #<TIME-SERIES-DATASET>
 DIMENSIONS: standard error
 TYPES:      NUMERIC
 FREQUENCY:  4
 START:      (1962 2)
 END:        (1983 1)
 POINTS:     84
 TIME-LABEL: year season

 TS-AR(6): (setq traffic (time-series-data
                          (read-data-from-file "sample/mawi-traffic/pointF-20090330-0402.sexp")
                          :except '(0) :time-label 0))
 #<TIME-SERIES-DATASET>
 DIMENSIONS: [   32-   63] | [   64-  127] | [  128-  255] | [  256-  511] | [  512- 1023] | ...
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | ...
 FREQUENCY:  1
 START:      (1 1)
 END:        (385 1)
 POINTS:     385
 TIME-LABEL: Time

 TS-AR(7): (parcor-filtering traffic :ppm-fname "traffic.ppm")
 #<TIME-SERIES-DATASET>
 DIMENSIONS: [   32-   63] | [   64-  127] | [  128-  255] | [  256-  511] | [  512- 1023] | ...
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | ...
 FREQUENCY:  1
 START:      (1 1)
 END:        (35 1)
 POINTS:     35
 TIME-LABEL: Time

** Exponential-Smoothing (HoltWinters)
Package for exponential-smoothing
*** Class
**** holtwinters-model
- accessors:
  - exp-type : :single | :double | :triple, type of exponential-smoothing
  - 3-params : Value for alpha, beta, gamma
  - err-info : Error measure function and its value
  - seasonal : :additive | :multiplicative, the way for seasonal adjustment
*** holtwinters ((d time-series-dataset) &key alpha beta gamma (err-measure 'mse) 
                                              (optim-step 0.1d0) (seasonal :additive))
- return: <holtwinters-model>
- arguments:
  - alpha : nil | 0 <= <double-float> <= 1
  - beta  : nil | 0 <= <double-float> <= 1
  - gamma : nil | 0 <= <double-float> <= 1
  - err-measure : 'mse | 'mape | 'rae | 're | 'rr
  - optim-step  : 0 <= <double-float> <= 1, step for optimizing alpha, beta and gamma
  - seasonal    : :additive | :multiplicative
- comments:
  when alpha, beta and gamma are nil, optimize those parameters by /optim-step/ and /err-measure/.\\
  Minimize the value of /err-measure/ to choose alpha, beta and gamma with optimization step specified by /optim-step/.\\
  Accordinglly, for example, /optim-step/ = 0.001d0 takes a long time.
*** predict ((model holtwinters-model) &key (n-ahead 0))
- return: <time-series-dataset>
- arguments:
  - model : <holtwinters-model>
  - n-ahead : <non-negative integer>
*** holtwinters-prediction
- return: (values <time-series-dataset> <holtwinters-model>)
- arguments:
  - d : <time-series-dataset>
  - alpha : nil | 0 <= <double-float> <= 1
  - beta  : nil | 0 <= <double-float> <= 1
  - gamma : nil | 0 <= <double-float> <= 1
  - err-measure : 'mse | 'mape | 'rae | 're | 'rr
  - optim-step  : 0 <= <double-float> <= 1
  - seasonal    : :additive | :multiplicative
  - n-ahead   : <non-negative integer>
  - n-learning : nil | <positive integer>, number of points for learning
  - target-col : nil | <string>, name of target parameter  
*** QUOTE sample usage
 EXPL-SMTHING(106): (setq ukgas (time-series-data (read-data-from-file "sample/UKgas.sexp")
                                                  :range '(1) :time-label 0
                                                  :frequency 4))
 #<TIME-SERIES-DATASET>
 DIMENSIONS: UKgas
 TYPES:      NUMERIC
 FREQUENCY:  4
 START:      (1 1)
 END:        (27 4)
 POINTS:     108
 TIME-LABEL: year season

 EXPL-SMTHING(108): (setq model (holtwinters ukgas :seasonal :multiplicative))
 #<HOLTWINTERS-MODEL>
 alpha: 0.1, beta: 0.2, gamma: 0.7999999999999999
 seasonal: MULTIPLICATIVE
 error: 1132.6785446257877 ( MSE )

 EXPL-SMTHING(109): (predict model :n-ahead 12)
 #<TIME-SERIES-DATASET>
 DIMENSIONS: UKgas
 TYPES:      NUMERIC
 FREQUENCY:  4
 START:      (1 2)
 END:        (30 4)
 POINTS:     119

 EXPL-SMTHING(110): (holtwinters-prediction ukgas :seasonal :multiplicative
                                            :n-learning 80
                                            :n-ahead 12)
 #<TIME-SERIES-DATASET>
 DIMENSIONS: UKgas
 TYPES:      NUMERIC
 FREQUENCY:  4
 START:      (1 2)
 END:        (30 4)
 POINTS:     119
 #<HOLTWINTERS-MODEL>
 alpha: 0.1, beta: 0.2, gamma: 0.7999999999999999
 seasonal: MULTIPLICATIVE
 error: 1132.6785446257877 ( MSE )

** ChangeFinder
Package for "ChangeFinder"
*** Class
**** changefinder
- accessors:
  - score-type : calculation method for change point score
  - ts-wsize : window size for 1st smoothing
  - score-wsize : window size for 2nd smoothing
  - discount : discounting parameter
*** init-changefinder ((ts time-series-dataset) &key (score-type :log) (ts-wsize 5) (score-wsize 5) (sdar-k 4) (discount 0.005d0)
- return: <changefinder>
- arguments:
  - ts          : <time-series-dataset>
  - score-type  : :log | :hellinger, :log for logarithmic loss, :hellinger for hellinger distance
  - ts-wsize    : <positive integer>, window size for 1st smoothing
  - score-wsize : <positive integer>, window size for 2nd smoothing
  - sdar-k      : <positive integer>, degree for AR
  - discount    : 0 < <double-float> < 1, discounting parameter
*** update-changefinder ((cf changefinder) new-dvec)
- return: (values score score-before-smoothing)
- arguments:
  - cf       : <changefinder>, return value of #'init-changefinder
  - new-dvec : vector representing time series data point
*** QUOTE sample usage
 CHANGEFINDER(189): (setf sample-ts
                      (time-series-data 
                       (read-data-from-file
                        "sample/traffic-balance.csv" 
                        :type :csv
                        :csv-type-spec (cons 'string
                                             (make-list 6 :initial-element 'double-float)))
                       :except '(0) :time-label 0))
 #<TIME-SERIES-DATASET >
 DIMENSIONS: IF1 | IF2 | IF3 | IF4 | IF5 | IF6
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
 NUMBER OF DIMENSIONS: 6
 FREQUENCY:  1
 START:      (1 1)
 END:        (1015 1)
 POINTS:     1015
 TIME-LABEL: TIME
 CHANGEFINDER(191): (setf changefinder (init-changefinder (sub-ts sample-ts :start 0 :end 24)))
 #<CHANGEFINDER @ #x1003506cb2>
 CHANGEFINDER(192): (loop for p across (ts-points (sub-ts sample-ts :start 24))
                        as new-dvec = (ts-p-pos p)
                        collect (update-changefinder changefinder new-dvec))
 (-1.3799530152768038 -1.3800702390966202 -1.3799904291394032 -1.380927096163571 -1.3812136176981418
  -1.3811039423658487 -1.381135210396757 -1.3812016491428545 -1.3815388293872684 -1.381304668982984
  ...)

*** Note
**** comments
- A value of 0.01 has been added to the diagonal elements of the covariance matrix
  for the stability of the inverse matrix calculation.
  User can edit this value by the special variable named *stabilizer*.
**** reference
- J. Takeuchi, K. Yamanishi "A Unifying framework for detecting outliers and change points from time series"
- K. Yamanishi "データマイニングによる異常検知" p.45-58
** Time-Series-Anomaly-detection
Package for time series anomaly detection tools
*** Class
**** snn : Class for Stochastic Nearest Neighbors
- accessors:
  - names   : names of parameter
  - snn-k   : number of neighbors
  - sigma-i : Lagrange-multiplier * const.
  - graphs  : list of local graphs
- reference:
  - T.Ide, S.Papadimitriou, M.Vlachos "Computing Correlation Anomaly Scores using Stochastic Nearest Neighbors"
*** make-db-detector ((ts time-series-dataset) &key beta (typical :svd) (pc 0.005d0) (normalize t))
- return: <Closure>
- arguments:
  - ts          : <time-series-dataset>, time series data for initialization
  - beta        : 0 < <double-float> < 1, discounting parameter
  - typical     : :svd | :mean, method for typical pattern, :svd for singular valur decomposition, :mean for average
  - pc          : 0 < <double-float> < 1, upper cumulative probability for threshold calculation
  - normalize   : nil | t, normalize vector (t) or not (nil)
- arguments for <Closure>:
  - new-dvec : vector representing time series data point
- return of <Closure>: (values score threshold typical-pattern-vector)
- descriptions:
  - Direction-based anomaly detection
  - reference:
    T.Ide and H.Kashima "Eigenspace-based Anomaly Detection in Computer Systems" section 5
  - The number of points in ts is window size.
*** make-periodic-detector ((ts time-series-dataset) &key (r 0.5d0))
- return: <Closure>
- arguments:
  - ts : <time-series-dataset>, time series data for initialization
  - r  : 0 < <double-float> < 1, discounting parameter
- arguments for <Closure>:
  - new-dvec : vector representing time series data point
- return of <Closure>: plist (:score for anomaly score, :local-scores for local anomaly scores)
- descriptions:
  - Anomaly detection in consideration of the periodicity
  - Define the multidimensional normal distribution at each point within a cycle, to a local anomaly score standard score abnormality score, conditional Gaussian Mahalanobis distance.
  - The value of r is used for updating of multidimensional normal distribution.
  - The value of ts-freq for ts is regarded as the number of points in a cycle.
*** QUOTE sample usage for make-db-detector and make-periodic-detector
 TS-ANOMALY-DETECTION(4): (setf sample-ts
                            (time-series-data
                             (read-data-from-file
                              "sample/traffic-balance.csv" 
                              :type :csv
                              :csv-type-spec (cons 'string
                                                   (make-list 6 :initial-element 'double-float)))
                             :frequency 12 :except '(0) :time-label 0))
 ; Autoloading for (SETF EOL-CONVENTION):
 ; Fast loading from bundle code/efmacs.fasl.
 ; Fast loading from bundle code/ef-e-anynl.fasl.
 ;   Fast loading from bundle code/ef-e-crlf.fasl.
 ;   Fast loading from bundle code/ef-e-cr.fasl.
 ; Fast loading from bundle code/ef-e-crcrlf.fasl.
 #<TIME-SERIES-DATASET >
 DIMENSIONS: IF1 | IF2 | IF3 | IF4 | IF5 | IF6
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
 NUMBER OF DIMENSIONS: 6
 FREQUENCY:  12
 START:      (1 1)
 END:        (85 7)
 POINTS:     1015
 TIME-LABEL: TIME
 TS-ANOMALY-DETECTION(5): (loop with detector = (make-db-detector 
                                                 (sub-ts sample-ts :start '(1 1) :end '(2 12)))
                              for p across (ts-points (sub-ts sample-ts :start '(3 1)))
                              collect (funcall detector (ts-p-pos p)))
 (7.689004308083502e-4 8.690742068634405e-4 0.0014640360422599752 9.645504419952822e-4 0.002189430044882701 0.0022804402419548397 8.653971028227403e-4 0.0021245846566718685 0.0021297890535286745
  0.003035579690776613 ...)
 TS-ANOMALY-DETECTION(6): (loop with detector = (make-periodic-detector
                                                 (sub-ts sample-ts :start '(1 1) :end '(2 12)))
                              for p across (ts-points (sub-ts sample-ts :start '(3 1)))
                              collect (funcall detector (ts-p-pos p)))
 ((:SCORE 0.15980001156818346 :LOCAL-SCORES (-0.011247495797210605 0.04067641708837213 0.07657475988236122 0.026173388386296143 -0.001005722797717759 -0.13117336322290166))
  (:SCORE 0.16606559269099325 :LOCAL-SCORES (-0.04404576382434579 0.08836079938698248 0.06427181525186569 0.008060984870295258 6.037724071195098e-5 -0.11672432427082227))
  (:SCORE 0.0835963350476519 :LOCAL-SCORES (0.02860344056963936 0.02049834345000817 0.018558627759386243 0.005805395166900154 -1.7563302955435247e-4 -0.07329208280202894))
  (:SCORE 0.10895276517361178 :LOCAL-SCORES (0.06171796944486013 0.02627577908981959 -0.0013938026860552477 7.108933807211727e-4 -0.0015292225676566903 -0.08581498358943485))
  (:SCORE 0.14372822478142372 :LOCAL-SCORES (0.019119719424318164 0.06530386435337952 -0.03223066630047898 0.05779465755012304 -0.0021226015789952857 -0.10789806554381363))
  (:SCORE 0.1214316386275602 :LOCAL-SCORES (0.08180945936566704 -0.01666669357385849 0.01789677418744477 -0.08623381474472612 -5.783555512765765e-4 0.003743461124108086))
  (:SCORE 0.16328621183435152 :LOCAL-SCORES (0.09252923344792947 0.04206473653695766 0.03524081165133149 -0.10442527700870255 -6.866050459105892e-4 -0.06471611713622019))
  (:SCORE 0.17165824330218574 :LOCAL-SCORES (0.1124055553487212 -0.04483642919806279 0.06943579226133692 -0.08609866163195316 -1.3815655640593742e-4 -0.05081348776600684))
  (:SCORE 0.14705276128118872 :LOCAL-SCORES (0.03176665855145954 -0.05169044126068538 0.11199895677113193 -0.020881754613730465 -0.0013360512015534781 -0.06969391195126472))
  (:SCORE 0.1753941034019109 :LOCAL-SCORES (0.0926869320817864 -0.04500698002481467 0.08111355541737571 -0.010867820410934509 -0.0027675310185543865 -0.11509576770374046)) ...)
*** make-snn ((ts time-series-dataset) k &key (sigma-i 1d0))
- return: <snn>
- arguments:
  - ts      : <time-series-dataset>
  - k       : number of neighbors
  - sigma-i : Lagrange-multiplier * const.
*** e-scores ((target-snn snn) (reference-snn snn))
- return: alist (key:name-of-parameter, value:E-score)
- arguments:
  - target-snn    : <snn>, target SNN
  - reference-snn : <snn>, reference SNN
- descriptions:
  - reference:
    T.Ide, S.Papadimitriou, M.Vlachos "Computing Correlation Anomaly Scores using Stochastic Nearest Neighbors"
  - Graph-based (correlation) anomaly detection
*** make-eec-detector ((ts time-series-dataset) window-size &key (xi 0.8d0) (global-m 3))
- return: <Closure>
- arguments:
  - ts : <time-series-dataset>, time series data for initialization
  - window-size : positive integer, window size
  - xi : 0 < <double-float> < 1, threshold for correlation strength
  - global-m : positive integer, the number of eigen values for global feature
- arguments for <Closure>:
  - new-dvec : vector representing time series data point
- return of <Closure>: plist (:score for anomaly score, :local-scores for local anomaly scores)
- descriptions:
  - reference:
    S.Hirose, et.al "Network Anomaly Detection based on Eigen Equation Compression"
  - Correlation-based anomaly detection
*** QUOTE sample usage for SNN and EEC
 TS-ANOMALY-DETECTION(8): (setf exchange 
                            (time-series-data
                             (read-data-from-file
                              "sample/exchange.csv" 
                              :type :csv
                              :csv-type-spec (cons 'string
                                                   (make-list 10 :initial-element 'double-float)))
                             :except '(0) :time-label 0))
 #<TIME-SERIES-DATASET >
 DIMENSIONS: CAD/USD | EUR/USD | JPY/USD | GBP/USD | CHF/USD | AUD/USD | HKD/USD | NZD/USD | KRW/USD | MXN/USD
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
 NUMBER OF DIMENSIONS: 10
 FREQUENCY:  1
 START:      (1 1)
 END:        (753 1)
 POINTS:     753
 TIME-LABEL: YYYY/MM/DD
 TS-ANOMALY-DETECTION(9): (let ((target-snn (make-snn (sub-ts exchange :start 1 :end 150) 3))
                                (reference-snn (make-snn (sub-ts exchange :start 600 :end 700) 3)))
                            (e-scores target-snn reference-snn))
 (("AUD/USD" . 0.47406298323897705) ("CAD/USD" . 0.5240011355714634) ("CHF/USD" . 0.5325785438502517) ("EUR/USD" . 0.731769158687747) ("GBP/USD" . 0.596827444239165) ("HKD/USD" . 0.5766733684269696)
  ("JPY/USD" . 0.5117506042665696) ("KRW/USD" . 0.5198055610159624) ("MXN/USD" . 0.7027828954312578) ("NZD/USD" . 0.2842836687583187))
 TS-ANOMALY-DETECTION(10): (loop with detector = (make-eec-detector
                                                  (sub-ts exchange :start 1 :end 60) 20)
                               for p across (ts-points (sub-ts exchange :start 60))
                               collect (funcall detector (ts-p-pos p)))
 ((:SCORE 2.700571112024573 :LOCAL-SCORES
   (-3.7189814823543945 1.0326461685226247 -0.09199334202340251 -1.5304334860393167 1.6336817412409927 0.09973192007442783 -1.7705007982055647 -1.3659133055436354 1.6229166989275772 -2.456418564898763))
  (:SCORE 2.2333558257821577 :LOCAL-SCORES
   (-3.905638387254389 1.0111353552477693 -0.16180107817711298 -0.06211424245500806 2.444035892878855 -0.7941221366494797 -2.0601881585490758 -0.6032554617242315 1.3644194991066583 -2.94095956222471))
  (:SCORE 1.9868164604264957 :LOCAL-SCORES
   (-4.071453905957172 0.09987314488820478 -0.5124850991763434 0.3572466274370432 1.985594397643084 -1.2627672914256596 -2.0286025799206437 -2.0180011854462823 1.0031799987968517 -3.349034884667727))
  (:SCORE 1.99119158115065 :LOCAL-SCORES
   (-4.21295552995317 3.6696601922048 0.13498367839300002 2.202025796055173 1.5652235278554427 -1.5185993444794728 -1.9951097435792884 -2.141676229907566 0.536949673309007 0.13587904258754527))
  (:SCORE 1.655330278980456 :LOCAL-SCORES
   (-3.940751233076124 1.4944533102503788 -1.134801399167889 1.0953740695897256 0.8538413750781987 -2.6483828385806047 -1.9833372992457443 -2.1457229135357965 -0.25535073809135234 -1.1228770376956778))
  (:SCORE 1.6026376553309072 :LOCAL-SCORES
   (-0.034554670356311185 1.2292838508330988 1.132721967732395 -0.7371812412223815 -1.2217525313170159 -3.7170161170631384 -0.8394971355287675 -2.309275510777308 -0.6893891878271913 -1.2247368414257422))
  (:SCORE 1.4921358653856052 :LOCAL-SCORES
   (-1.1119582168928317 0.13109381389384833 0.03822852402739136 -1.2567269843174933 -1.0016538526115792 -3.7378375887102315 0.0018749768626725657 -2.1904933121802066 -1.0031674527371155
    -1.8580823578222343))
  (:SCORE 1.834987095608023 :LOCAL-SCORES
   (-2.411063158982719 -0.9462790230517837 -0.5412882072844031 -1.8686452258034443 -2.4080116434386505 -4.2224169886297185 -0.19950597770025008 -2.1142292908200604 0.49105626655832846 -1.4030218415732563))
  (:SCORE 1.0321828011949825 :LOCAL-SCORES
   (-3.2832950290358296 -1.7201312662081096 -0.806431510082311 -0.49749735373008097 -2.3879869063190085 -4.243481779019334 -1.1894302963419576 -2.5038090216601767 -0.1556970436113533 -1.4378596777323336))
  (:SCORE 0.5533902042593536 :LOCAL-SCORES
   (-3.7083233694175766 -1.6133834329235863 -0.01938368944029429 -0.6476096999243521 0.03650134747649691 -3.3240586306405393 -1.8620675130088626 -1.7836998046168742 -0.875130410874981 -1.9750969929005304))
  ...)
** Read-Graph
*** make-simple-graph (id-name-alist &key edgelist directed)
- argument:
  - id-name-alist : association list of node's ID and name. ID is a positive integer, there are no gaps.
  - edgelist : list of plist, plist is like (:nid1 <initial-vertex-ID> :nid2 <terminal-vertex-ID> :weight <weight-for-edge>)
  - directed : t | nil, the graph is directed or not.
*** QUOTE sample usage
READ-GRAPH(19): (let* ((id-name-alist (loop for i from 1 to 6
                                          collect (cons i (format nil "~A" i))))
                       (edgelist (list (list :nid1 1 :nid2 2 :weight 1d0)
                                       (list :nid1 2 :nid2 3 :weight 1d0)
                                       (list :nid1 2 :nid2 5 :weight 1d0)
                                       (list :nid1 4 :nid2 5 :weight 1d0)
                                       (list :nid1 5 :nid2 6 :weight 1d0)
                                       (list :nid1 6 :nid2 4 :weight 1d0))))
                  (make-simple-graph id-name-alist 
                                     :edgelist edgelist
                                     :directed nil))
#<SIMPLE-GRAPH >
6 nodes
6 links
** Graph-Centrality
*** eccentricity-centrality (graph)
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* )), vector of centraliry
- argument:
  - graph: return value of #'make-simple-graph
*** closeness-centrality (graph &key standardize)
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* )), vector of centraliry
- argument:
  - graph: return value of #'make-simple-graph
  - standardize: t | nil, standardize centrality or not
*** degree-centrality (graph &key mode standardize)
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* )), vector of centraliry
- argument:
  - graph: return value of #'make-simple-graph
  - mode: :in | :out
  - standardize: t | nil, standardize centrality or not
*** eigen-centrality (graph)
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* )), vector of centraliry
          DOUBLE-FLOAT, eigenvalue
- argument:
  - graph: return value of #'make-simple-graph
*** pagerank (graph &key (c 0.85d0))
- return: (SIMPLE-ARRAY DOUBLE-FLOAT (* )), vector of centraliry
- argument:
  - graph: return value of #'make-simple-graph
  - c : ratio for transition probability matrix
- reference:
  L. Page, S. Brin, R. Motwani, T. Winograd "The PageRank citation ranking: Bringing order to the web." 1999
*** QUOTE sample usage
GRAPH-CENTRALITY(36): (setf gr (let* ((id-name-alist (loop for i from 1 to 6
                                                         collect (cons i (format nil "~A" i))))
                                      (edgelist (list (list :nid1 1 :nid2 2 :weight 1d0)
                                                      (list :nid1 2 :nid2 3 :weight 1d0)
                                                      (list :nid1 2 :nid2 5 :weight 1d0)
                                                      (list :nid1 4 :nid2 5 :weight 1d0)
                                                      (list :nid1 5 :nid2 6 :weight 1d0)
                                                      (list :nid1 6 :nid2 4 :weight 1d0))))
                                 (make-simple-graph id-name-alist 
                                                    :edgelist edgelist
                                                    :directed nil)))
#<SIMPLE-GRAPH >
6 nodes
6 links
GRAPH-CENTRALITY(37): (eccentricity-centrality gr)
#(0.3333333333333333 0.5 0.3333333333333333 0.3333333333333333 0.5 0.3333333333333333)
GRAPH-CENTRALITY(38): (closeness-centrality gr)
#(0.09090909090909091 0.14285714285714285 0.09090909090909091 0.1 0.14285714285714285 0.1)
GRAPH-CENTRALITY(39): (degree-centrality gr)
#(1.0 3.0 1.0 2.0 3.0 2.0)
GRAPH-CENTRALITY(40): (eigen-centrality gr)
#(0.18307314221469623 0.41711633875524184 0.18307314221469628 0.45698610699552694
  0.5842172585338801 0.45698610699552716)
2.2784136094964444
GRAPH-CENTRALITY(41): (pagerank gr)
#(0.22515702990803205 0.5915609362243119 0.22515702990803205 0.3631199718377685 0.5338090057356462
  0.3631199718377685)

** Text-Utilities
   text utility functions
*** calculate-string-similarity (str1 str2 &key type)
- return: number of similarity
- arguments:
  - str1: <string>
  - str2: <string>
  - type: :lev | :lcs
- comments:
  :lev for /type/, calculate similarity by levenshtein distance.\\
  :lcs for /type/, calculate similarity by lcs distance.
*** equivalence-clustering (data-vector)
- return: clustering results list
- arguments:
  - data-vector : #(string-a,string-b,...,label), label = 1.0 <->(a~b), label = -1.0 <-> not (a~b)
*** QUOTE sample usage
TEXT-UTILS(4): (calculate-string-similarity "kitten" "sitting" :type :lev)
0.5384615384615384
TEXT-UTILS(5): (calculate-string-similarity "kitten" "sitting" :type :lcs)
0.6153846153846154
TEXT.UTILS(42): (setf data (read-data-from-file "sample/equivalence-class.csv" :type :csv :csv-type-spec
 '(string string double-float) :external-format :utf-8))
 #<UNSPECIALIZED-DATASET>
DIMENSIONS: string1 | string2 | label
TYPES:      UNKNOWN | UNKNOWN | UNKNOWN
DATA POINTS: 7 POINTS
TEXT-UTILS(43): (dataset-points data)
 #(#("x" "y" 1.0) #("y" "z" 1.0) #("x" "w" -1.0) #("a" "b" 1.0) #("c" "c" 1.0) #("e" "f" -1.0) #("f" "x" 1.0))
TEXT-UTILS(44): (equivalence-clustering *)
(("e") ("f" "z" "y" "x") ("c") ("b" "a") ("w"))
** Hierarchical-Dirichlet-Process-Latent-Dirichlet-Allocation
Package for Latent-Dirichlet-Allocation by Hierarchical-Dirichlet-Process
*** Class
**** hdp-lda
- accessor:
  - topic-count: <integer>, number of topics
  - hdp-lda-alpha: value of hyperparameter alpha
  - hdp-lda-beta: value of hyperparameter beta
  - hdp-lda-gamma: value of hyperparameter gamma
*** hdp-lda (dataset &key (sampling 100) hyper-parameters (initial-k 0))
- return: <numeric-dataset>, Probability of topics for each document
          <numeric-and-category-dataset>, Probability of words for each topic
          <hdp-lda>
- arguments:
  - dataset: <numeric-dataset>, refer descriptions
  - sampling: <integer>, number of sampling, default is 100
  - hyper-parameters: <list double-float>, initial values for hyperparameter alpha, beta and gamma. default values are random number of gamma-distribution.
  - initial-k: <integer>, initial value for number of topic. default is 0.
- descriptions:
  - Each column of /dataset/ represents frequency of the word in a document. And the name of column is the word itself.\\
    So each row of /dataset/ represents the vector of frequency of word for a document.
  - Each column of the first of /return/ corresponds to a topic, and its value denotes the probability that the document belong to the topic.
  - Each column of the second of /return/ corresponds to a word, and its value denotes the probability of word for the topic.
- references:
  - Latent Dirichlet Allocation, David M Blei, Andrew Y.Ng, Michael I.Jordan. \\
    Journal of Machine Learning Research 3 (2003) 993-1022.
  - Hierarchical Dirichlet Processes, Yee Whye Teh, Michael I Jordan, Matthew J Beal, David M Blei. \\
    Journal of the American Statistical Association. December 1, 2006, 101(476): 1566-1581.
  - [[http://cl-www.msi.co.jp/solutions/knowledge/lisp-world/tutorial/hdp-lda.pdf][ノンパラメトリックベイズ言語モデルによるコーパス内トピック抽出]]
*** get-trend-topics (model &key (trend :hot) (ntopics 10) (nwords 10))
- return: <alist>, key: Topic ID, datum: (cons vector-of-words mean-value-of-theta)
- arguments:
  - model  : <hdp-lda>, hdp-lda
  - trend  : :hot | :cold, default is :hot
  - ntopics: <integer>, default is 10
  - nwords : <integer>, default is 10
- description:
  - Information on the topic of /ntopics/ piece is returned in order of /:hot/ or /:cold/ trend. \\
    And /vector-of-words/ ( length /nwords/ ) for each topic is sorted by the probability of appearance.
- reference:
  - [[http://www.ncbi.nlm.nih.gov/pmc/articles/PMC387300/][Finding scientific topics, Thomas L.Griffiths, Mark Steyvers: 5232-5234]]
    
*** QUOTE sample usage
 HDP-LDA(142): (setq dataset (pick-and-specialize-data
                              (read-data-from-file "sample/sports-corpus-data" :external-format :utf-8)
                              :except '(0) :data-types (make-list 1202 :initial-element :numeric)))
 #<NUMERIC-DATASET>
 DIMENSIONS: �������� | �������� | ���������������� | �������� | ������������ | ���������������� | �������� | ������������ | ������������ | ������������ ...
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC ...
 NUMBER OF DIMENSIONS: 1202
 NUMERIC DATA POINTS: 100 POINTS

 HDP-LDA(145): (hdp-lda dataset)
 #<NUMERIC-DATASET>
 DIMENSIONS: Topic 1 | Topic 2 | Topic 3 | Topic 4 | Topic 5 | Topic 6 | Topic 7 | Topic 8 | Topic 9 | Topic 10 ...
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC ...
 NUMBER OF DIMENSIONS: 42
 NUMERIC DATA POINTS: 100 POINTS
 #<NUMERIC-AND-CATEGORY-DATASET >
 DIMENSIONS: Topic ID | �������� | �������� | �������� | ���� | �������� | ������������ | �������� | �������� | �������� ...
 TYPES:      CATEGORY | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC ...
 NUMBER OF DIMENSIONS: 1202
 CATEGORY DATA POINTS: 42 POINTS
 NUMERIC DATA POINTS: 42 POINTS
 #<HDP-LDA @ #x1003b8a402>

 HDP-LDA(150): (topic-count (third /))
 42

 HDP-LDA(148): (get-trend-topics (third //) :trend :hot)
 (("Topic 9" #("��������" "��������" "��������" "��������" "��������" "��������" "��������" "������������" "��������" "����������������") . 0.038236246008561785)
  ("Topic 2" #("��������" "��������" "����������������" "��������" "����������������������������" "��������" "����������������" "��������" "��������" "��������������������") . 0.036524581128946985)
  ("Topic 13" #("��������" "��������" "������������" "��������" "��������" "��������" "��������" "��������" "��������������������" "������������") . 0.034852503455076525)
  ("Topic 3" #("��������" "��������" "��������" "��������" "��������" "��������" "��������" "������������" "��������" "������������") . 0.031009372447135867)
  ("Topic 1" #("������������" "��������" "��������" "��������" "��������" "��������" "��������" "����������������" "����������������" "��������") . 0.028643711953003095)
  ("Topic 22" #("������������" "������������" "��������" "��������" "��������" "��������" "��������" "������������" "��������" "��������") . 0.027999110059900734)
  ("Topic 17" #("��������" "��������" "������������" "��������" "��������" "����������������" "��������" "������������" "��������" "������������") . 0.024662779329262353)
  ("Topic 5" #("��������" "��������" "��������" "��������" "��������" "��������" "��������" "��������" "��������" "��������") . 0.02460766056146378)
  ("Topic 21" #("��������" "��������" "��������" "��������" "������������" "��������" "��������" "����������������" "����" "������������") . 0.02451716039711171)
  ("Topic 35" #("��������" "��������" "������������" "��������" "��������" "��������" "��������" "������������" "��������" "����������������") . 0.02444346223102492))

** Dirichlet-Process-Mixture
Package for Dirichlet Process Mixture
*** Class
**** multivar-gauss-dpm
- accessor:
  - dpm-k : number of clusters
  - dpm-hyper: hyperparameter of DPM clustering. This value represents the tendency of making new cluster.
  - dpm-base : <multivar-dp-gaussian>, prior distribution
**** multivar-dp-gaussian
- accessor:
  - average-of-average : (SIMPLE-ARRAY DOUBLE-FLOAT (* )), average of centroids
  - std-of-average : (SIMPLE-ARRAY DOUBLE-FLOAT (* * )), covariance matrix of centroids
  - average-of-std : (SIMPLE-ARRAY DOUBLE-FLOAT (* * )), average of covariance matrix
*** gaussian-dpm (dataset &key sampling estimate-base average-of-average std-of-average average-of-std)
- return: <numeric-and-category-dataset>, The name of last column is "ClusterID".
          <multivar-gauss-dpm>
- arguments:
  - dataset : <numeric-dataset>, points
  - sampling : <integer>, number of sampling, default is 100
  - estimate-base : nil | t, estimate parameters of prior distribution from /dataset/, default is nil
  - average-of-average : nil | (SIMPLE-ARRAY DOUBLE-FLOAT (* ))
  - std-of-average : nil | (SIMPLE-ARRAY DOUBLE-FLOAT (* * ))
  - average-of-std : nil | (SIMPLE-ARRAY DOUBLE-FLOAT (* * ))
- description:
  - DPM clustering by multivaliate mixture of gaussian, estimate number of clusters ( /dpm-k/ ) by assuming
    the distribution of points is mixture of gaussian.
  - When /estimate-base/ is t, parameters for prior distribution will be ignored.
- reference:
  - [[http://biocomp.bioen.uiuc.edu/journal_club_web/dirichlet.pdf][The Dirichlet Process Mixture (DPM) Model, Ananth Ranganathan.]]
  - [[http://cl-www.msi.co.jp/solutions/knowledge/lisp-world/tutorial/dpm.pdf][混合ディリクレ過程について]]
*** get-cluster-info (model)
- return: <list plist>
- argument:
  - model : <multivar-gauss-dpm>, second return value of /gaussian-dpm/
- description:
  keys of plist of return
  - :CLUSTER-ID, cluster id
  - :SIZE, size of the cluster
  - :CENTER, centroid
  - :STD, covariance matrix of the cluster
*** get-cluster-parameter (model)
- return: <list plist>
- argument:
  - model : <multivar-gauss-dpm>, second return value of /gaussian-dpm/
- description:
  It returns parameters ( mean and covariance matrix ) of multivariate gaussian distribution corresponding to cluster.\\
  keys of plist of return
  - :CLUSTER-ID, cluster id
  - :CENTER, center of gaussian distribution
  - :STD, covariance matrix of gaussian distribution
*** QUOTE sample usage
 DPM(120): (setq dataset (pick-and-specialize-data
                          (read-data-from-file "sample/k5-gaussian.sexp")
                          :data-types (make-list 5 :initial-element :numeric)))
 #<NUMERIC-DATASET >
 DIMENSIONS: X_1 | X_2 | X_3 | X_4 | X_5
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC
 NUMBER OF DIMENSIONS: 5
 NUMERIC DATA POINTS: 300 POINTS

 DPM(121): (gaussian-dpm dataset :estimate-base t)
 #<NUMERIC-AND-CATEGORY-DATASET >
 DIMENSIONS: X_1 | X_2 | X_3 | X_4 | X_5 | ClusterID
 TYPES:      NUMERIC | NUMERIC | NUMERIC | NUMERIC | NUMERIC | CATEGORY
 NUMBER OF DIMENSIONS: 6
 CATEGORY DATA POINTS: 300 POINTS
 NUMERIC DATA POINTS: 300 POINTS
 #<MULTIVAR-GAUSS-DPM @ #x1002ecb2b2>

DPM(122): (get-cluster-info (second /))
((:CLUSTER-ID "1" :SIZE 141 :CENTER
  #(-4.747700248123091 1.3622318562869662 1.2782023159574585 -2.141195509247461 -3.4556686133799595) :STD
  #2A((35.60389006155842 29.427271354390463 82.80651251227518 124.87704188705925 -33.59239185128833)
      (29.427271354390463 90.11959625228705 101.44877180112098 125.67666875563408 -17.202480684617967)
      (82.80651251227518 101.44877180112098 251.07172703212572 292.284337786455 -86.62394096668947)
      (124.87704188705925 125.67666875563408 292.284337786455 627.4247158252784 -93.840489838668)
      (-33.59239185128833 -17.202480684617967 -86.62394096668947 -93.840489838668 88.16261301496588)))
 (:CLUSTER-ID "2" :SIZE 48 :CENTER
  #(-1.3978236125361367 14.363041280783806 8.308822999052236 3.657664897655149 -1.5567793498584357) :STD
  #2A((3.767712686833649 0.31614353352887714 -2.835169406361532 2.3375365913940502 0.7164413072489306)
      (0.31614353352887714 0.282573896314404 -0.20770532160950034 0.34272235157066705 0.26639420374491574)
      (-2.835169406361532 -0.20770532160950034 2.3801180410598715 -1.766188923516638 -0.4243990299151502)
      (2.3375365913940502 0.34272235157066705 -1.766188923516638 1.689398703524526 0.5841722532589274)
      (0.7164413072489306 0.26639420374491574 -0.4243990299151502 0.5841722532589274 0.5146158604998269)))
 (:CLUSTER-ID "3" :SIZE 24 :CENTER
  #(0.8208447613686887 17.744167940632387 0.8099194775398636 5.2929959296754205 1.1353267885640488) :STD
  #2A((0.8972762489684213 -0.31887433358161804 -0.18098271346921407 -0.6538816945178471 -1.478502920942065)
      (-0.31887433358161804 0.41945134699028763 0.1502440988646348 0.5326213287238147 0.4937517995855798)
      (-0.18098271346921407 0.1502440988646348 0.22063689138750403 0.2125782467536725 0.3567261667741095)
      (-0.6538816945178471 0.5326213287238147 0.2125782467536725 0.8628847826205338 1.0992977137389952)
      (-1.478502920942065 0.4937517995855798 0.3567261667741095 1.0992977137389952 3.054640990068194)))
 (:CLUSTER-ID "4" :SIZE 18 :CENTER
  #(-2.5313305347810693 3.2894262067638915 8.173988415834913 -2.114233321320084 -7.861194673153906) :STD
  #2A((1.3552265575725049 -0.6926831700887587 -0.26588787283050863 -0.8622036787737362 3.6895836724504165)
      (-0.6926831700887587 4.0317686239429795 -2.1835751519540976 5.661849483204463 -13.588348532052338)
      (-0.26588787283050863 -2.1835751519540976 1.8553378231357107 -3.6558282842699095 7.29795584843779)
      (-0.8622036787737362 5.661849483204463 -3.6558282842699095 9.513280378480776 -21.203169039333886)
      (3.6895836724504165 -13.588348532052338 7.29795584843779 -21.203169039333886 51.41770262953003)))
 (:CLUSTER-ID "5" :SIZE 6 :CENTER
  #(-1.864515406980126 18.67653046593828 2.695001479543812 7.103235491433397 4.777045132904577) :STD
  #2A((0.6126557816898444 -1.1376041384423559 1.3478531382829178 -0.885506033663957 -1.759789251001696)
      (-1.1376041384423559 3.7480785177652822 -4.062529194535606 2.9327465610742447 4.689851191850602)
      (1.3478531382829178 -4.062529194535606 5.021795314435778 -3.110963786028006 -6.035139800203711)
      (-0.885506033663957 2.9327465610742447 -3.110963786028006 2.3733411039467094 3.4947744229891984)
      (-1.759789251001696 4.689851191850602 -6.035139800203711 3.4947744229891984 7.541057312611937)))
 (:CLUSTER-ID "6" :SIZE 5 :CENTER
  #(3.8405356633848946 15.65166708886644 -0.5638871385803196 2.0525649675857833 -3.1232848531588946) :STD
  #2A((0.4959817713182971 -0.05238175833813438 0.014444685643597454 -0.1128425501065371 -0.9247087836543406)
      (-0.05238175833813438 0.0439012152641306 0.015840070169276136 0.07946819705047137 0.28305538587817447)
      (0.014444685643597454 0.015840070169276136 0.07835912481817245 0.04431328474783994 -0.012825288434576199)
      (-0.1128425501065371 0.07946819705047137 0.04431328474783994 0.23456007972225668 0.6546747968817377)
      (-0.9247087836543406 0.28305538587817447 -0.012825288434576199 0.6546747968817377 2.9012567652739176)))
 (:CLUSTER-ID "7" :SIZE 5 :CENTER
  #(-9.281287864391278 -9.55523121933028 -18.528169491288793 -9.98199613809988 3.4219371967361214) :STD
  #2A((0.10660821515300806 -0.00733277413058292 0.41402496560334157 0.7575383487798295 -0.1260033259608938)
      (-0.00733277413058292 0.38077172613055327 -0.002665231074823249 -0.14167894603185588 0.20900014970658654)
      (0.41402496560334157 -0.002665231074823249 2.475443626898237 4.308897106648791 -0.984058753806758)
      (0.7575383487798295 -0.14167894603185588 4.308897106648791 7.592529389328041 -1.7549983134763392)
      (-0.1260033259608938 0.20900014970658654 -0.984058753806758 -1.7549983134763392 0.5565212122827838)))
 (:CLUSTER-ID "8" :SIZE 3 :CENTER
  #(-10.90077395987349 -11.133826667754303 -21.289431097852543 -15.89002031139242 4.234470069825825) :STD
  #2A((0.041412084496967545 -0.001464484441054664 0.020629428059892846 0.03228367149853002 -0.04984713699366741)
      (-0.001464484441054664 0.04360275952019657 0.08729690466847953 0.09727005507834874 0.012675352366062832)
      (0.020629428059892846 0.08729690466847953 0.18819804423404157 0.21499463852112063 -0.002774551011331592)
      (0.03228367149853002 0.09727005507834874 0.21499463852112063 0.2475474904310713 -0.014200354939206208)
      (-0.04984713699366741 0.012675352366062832 -0.002774551011331592 -0.014200354939206208
       0.06273465486482163)))
 (:CLUSTER-ID "9" :SIZE 3 :CENTER
  #(-6.763991770982114 -7.468610366683064 -12.00114712352084 3.5107276014077393 1.037884974415101) :STD
  #2A((0.20997278723884 -0.3212880497495395 0.30634446641359964 0.24685881385553413 -0.5097610484643889)
      (-0.3212880497495395 0.5409795827962048 -0.4721747075917845 -0.38450774437057916 0.8427916521620691)
      (0.30634446641359964 -0.4721747075917845 0.44718562009189683 0.36063040751678055 -0.7480826512673684)
      (0.24685881385553413 -0.38450774437057916 0.36063040751678055 0.29115553771348135 -0.6079330372912501)
      (-0.5097610484643889 0.8427916521620691 -0.7480826512673684 -0.6079330372912501 1.3174276838360577)))
 (:CLUSTER-ID "10" :SIZE 3 :CENTER
  #(1.1450964698175774 15.285648428351596 5.055169885045917 4.034305413357854 -1.893463683661671) :STD
  #2A((3.129933291302472 1.6860864578136487 -6.570309345113937 -2.3823371970406866 -2.1747147890106286)
      (1.6860864578136487 0.9091527070534163 -3.5696966490797903 -1.2826396948018433 -1.1986669432962391)
      (-6.570309345113937 -3.5696966490797903 14.855895624540189 4.975726018607728 5.518643376153893)
      (-2.3823371970406866 -1.2826396948018433 4.975726018607728 1.813906181928049 1.6326478995895115)
      (-2.1747147890106286 -1.1986669432962391 5.518643376153893 1.6326478995895115 2.365840669310619)))
 ...)

DPM(123): (get-cluster-parameter (second //))
((:CLUSTER-ID "1" :CENTER
  #(-3.018666782084209 3.552285012692466 6.410516453829075 -2.2828651468331955 0.38977147754631447) :STD
  #2A((0.08790217485499387 0.0 0.0 0.0 0.0)
      (4.2265567203832177e-4 0.03549378475411256 0.0 0.0 0.0)
      (-0.02278763431915076 -0.006497923437300842 0.02096776069335603 0.0 0.0)
      (-0.007474301551347596 -0.001252156713202957 -0.004798350536619937 0.015340496389350332 0.0)
      (7.941652178942941e-4 0.0038873197529791658 0.006924669113147595 0.0027302324923285564
       0.0213515467583617)))
 (:CLUSTER-ID "2" :CENTER
  #(-0.924328704166731 13.1851789705595 5.413151700392192 4.671851227467583 0.31990527722739337) :STD
  #2A((0.33664678762364764 0.0 0.0 0.0 0.0)
      (0.22062893861817282 0.46574588574978115 0.0 0.0 0.0)
      (0.08692347310740856 -0.11432071787411402 0.3593811568608045 0.0 0.0)
      (-0.381343210027365 -0.10256063718081146 0.4347395412700988 0.21997372537243215 0.0)
      (-0.0711968582262576 -0.29051775969998683 -0.10706487942366079 -0.09008281774029542 0.1320583625239039)))
 (:CLUSTER-ID "3" :CENTER
  #(-1.661297066291205 15.030895309937986 1.8544978873002664 4.029997394865564 1.6602363033901846) :STD
  #2A((2.8513310391085733 0.0 0.0 0.0 0.0)
      (0.5778962208350964 3.6788499863195994 0.0 0.0 0.0)
      (-0.010415466189933609 -0.5240649149320287 2.9378694380645705 0.0 0.0)
      (0.07424263840468392 -2.525041687814656 -0.11209380562159793 1.0951495762800536 0.0)
      (1.2578696428504756 0.6182665753464702 -0.38245634943044454 -0.3433057548662177 0.5285671877497882)))
 (:CLUSTER-ID "4" :CENTER
  #(-2.168693300986842 5.011025013496882 4.750133061109252 0.29647057181502506 -1.0648186497715801) :STD
  #2A((1.6947758436545703 0.0 0.0 0.0 0.0)
      (-0.5899782881732767 1.9524370792028023 0.0 0.0 0.0)
      (1.2433955611622793 1.395583672375188 1.095899215846985 0.0 0.0)
      (-0.8029180610656034 0.8219443760475856 1.0797116684962829 0.9342505319927961 0.0)
      (-0.7229097601580676 0.7272180034262397 0.2532969359854923 0.4508260318659607 0.11603060807275092)))
 (:CLUSTER-ID "5" :CENTER
  #(-2.029603616617132 15.37013354443578 2.57983270619288 6.456469718899851 3.202545819676383) :STD
  #2A((1.1474213364689838 0.0 0.0 0.0 0.0)
      (0.5170070640871127 0.7282860807469377 0.0 0.0 0.0)
      (0.01478041991205444 0.29392994863445066 0.7241703843528137 0.0 0.0)
      (0.45269452774265484 0.3095956728820788 0.15464281373392944 0.30133660948495256 0.0)
      (-0.32887429251545347 -0.16844920469969013 0.7598096459088705 0.034497334297136154 0.39766362371022834)))
 (:CLUSTER-ID "6" :CENTER
  #(-0.38374192642331906 14.069581451971176 1.1193854701649864 4.866443089492931 2.4820497041387384) :STD
  #2A((0.6620762188103568 0.0 0.0 0.0 0.0)
      (-0.10536010134199872 0.8938743837370757 0.0 0.0 0.0)
      (0.12210421870424257 0.9353616550431747 1.1735937355767068 0.0 0.0)
      (0.03696054092146503 -0.1757393869796806 -0.16254812039472286 1.0767067656636655 0.0)
      (0.42288077018998477 -0.599183511053974 -0.20951787503862968 0.00933887884393802 0.6150551658553179)))
 (:CLUSTER-ID "7" :CENTER
  #(-6.844624169753802 -4.019926387632049 -13.37675030584187 -10.840695888625595 4.862748371074806) :STD
  #2A((1.0805864078735172 0.0 0.0 0.0 0.0)
      (-0.6204571002438861 0.3917002284464556 0.0 0.0 0.0)
      (0.4827059697554091 -1.1271110185103606 0.8868718185414814 0.0 0.0)
      (0.15576976648162744 -0.2673713366184735 0.21721240869591493 0.31024818842712 0.0)
      (0.18747526834559314 -0.128885915349891 0.17691238014962496 -0.2703163565308579 0.26520552874740305)))
 (:CLUSTER-ID "8" :CENTER
  #(-8.67711381615341 -5.285500319548429 -18.750884878515166 -25.12506403866315 6.336295156329429) :STD
  #2A((0.942135835055004 0.0 0.0 0.0 0.0)
      (0.1477767754182805 0.2386272690670798 0.0 0.0 0.0)
      (0.1013628843746099 -0.5623037180403585 1.0004587535332845 0.0 0.0)
      (0.14415123055349158 0.7721590175622104 -0.22069884186447367 0.5692602970943657 0.0)
      (0.7007841569043352 0.2247212225920311 0.17076339957399062 0.46796220205916433 1.3279538176944936)))
 (:CLUSTER-ID "9" :CENTER
  #(-4.801686833132261 -0.6235422752197399 -5.454898383550407 2.514943631428041 1.224942349797682) :STD
  #2A((1.1019950441205288 0.0 0.0 0.0 0.0)
      (-0.47465312618267125 0.5505553079269279 0.0 0.0 0.0)
      (0.0863085547206749 -0.7747778950634414 0.8280196690794437 0.0 0.0)
      (0.12870552104861055 -0.13361131334910176 0.08310145360207415 1.362911309015303 0.0)
      (0.16723314131526046 0.024872141028506396 -0.26697087624881355 -0.4345524944706915 0.9205679453643515)))
 (:CLUSTER-ID "10" :CENTER
  #(-0.9428511141370942 14.352176636202765 1.0285674706952541 4.785664149177997 1.3188714738405038) :STD
  #2A((1.1059849180294237 0.0 0.0 0.0 0.0)
      (-0.47657796287157234 0.605595131646249 0.0 0.0 0.0)
      (-0.1777834386098767 0.08701713364505233 0.5423714777658503 0.0 0.0)
      (0.7823985366885251 0.3371587438076942 -0.24025678060201053 0.8677478956473136 0.0)
      (0.8234354221726298 0.21633297616455788 -0.0332667320555832 0.010903021023001764 0.7522075919738642)))
 ...)

* Statistics
** Requirements
The package does not depend on any libraries (yet). Any ANSI-compliant
Common Lisp should be enough. However, to load it easily, you need the
ASDF package (http://www.cliki.net/asdf).
** Usage
*** One-valued data
There is a range of functions that operate on a sequence of data.
**** mean (seq)
Returns the mean of SEQ.
**** median (seq)
Returns the median of SEQ.
(Variant: median-on-sorted (sorted-seq))
**** discrete-quantile (seq cuts)
Returns the quantile(s) of SEQ at the given cut point(s). CUTS can be a
single value or a list.
(Variant: discrete-quantile-on-sorted (sorted-seq cuts))
**** five-number-summary (seq)
Returns the "five number summary" of SEQ, ie. the discrete quantiles at the
cut points 0, 1/4, 1/2, 3/4 and 1.
(Variant: five-number-summary-on-sorted (sorted-seq))
**** range (seq)
Returns the difference of the maximal and minimal element of SEQ.
**** interquartile-range (seq)
Returns the interquartile range of SEQ, ie. the difference of the discrete
quantiles at 3/4 and 1/4.
(Variant: interquartile-range-on-sorted (sorted-seq))
**** mean-deviation (seq)
Returns the mean deviation of SEQ.
**** variance (seq)
Returns the variance of SEQ.
**** standard-deviation (seq &key populationp)
Returns the standard deviation of SEQ.
If populationp is true, the returned value is the population standard deviation.
Otherwise, it is the sample standard deviation.
*** Two-valued data
These functions operate on two sequences.
**** covariance (seq1 seq2)
Returns the covariance of SEQ1 and SEQ2.
**** linear-regression (seq1 seq2)
Fits a line y = A + Bx on the data points from SEQ1 x SEQ2. Returns (A B).
**** correlation-coefficient (seq1 seq2)
Returns the correlation coefficient of SEQ1 and SEQ2, ie.
covariance / (standard-deviation1 * standard-deviation2).
**** spearman-rank-correlation (seq1 seq2)
Returns the Spearman rank correlation, ie. the coefficient based on just
the relative size of the given values.
**** kendall-rank-correlation (seq1 seq2)
Returns the Kendall "tau" rank correlation coefficient.
*** Distributions
Distributions are CLOS objects, and they are created by the constructor
of the same name. The objects support the methods CDF (cumulative
distribution function), DENSITY (MASS for discrete distributions),
QUANTILE, RAND (gives a random number according to the given distribution),
RAND-N (convenience function that gives n random numbers), MEAN and
VARIANCE (giving the distribution's mean and variance, respectively).
These take the distribution as their first parameter.

Most distributions can also be created with an estimator constructor.
The estimator function has the form <distribution>-ESTIMATE, unless noted.

The following distributions are supported:
**** beta-distribution
- Parameters: shape1 shape2
**** binomial-distribution
- Parameters: size, probability
**** cauchy-distribution
- Parameters: location, scale
**** chi-square-distribution
- Parameters: degree
- Estimators: [none]
**** exponential-distribution
- Parameters: hazard (or scale)
**** f-distribution
- Parameters: degree1 degree2
- Estimators: [none]
**** gamma-distribution
- Parameters: scale, shape
- (Variant: erlang-distribution [shape is an integer])
- Numerical calculation:
  If there is a numerical problem with QUANTILE, QUANTILE-ILI would be solve it.\\
  ILI is abbreviation of the numerical calculation method of Inverse-Linear-Interpolation.\\
  However this is slower than Newton-Raphson(for QUANTILE).
**** geometric-distribution
- Parameters: probability
- (Supported on k = 1, 2, ... (the # of trials until a success, inclusive))
**** hypergeometric-distribution
- Parameters: elements, successes, samples
- Estimators: hypergeometric-distribution-estimate-successes-unbiased,
    hypergeometric-distribution-estimate-successes-maximum-likelihood,
    hypergeometric-distribution-estimate-elements
**** logistic-distribution
- Parameters: location, scale
**** log-normal-distribution
- Parameters: expected-value, deviation
- Estimators: log-normal-distribution-estimate-unbiased,
    log-normal-distribution-estimate-maximum-likelihood
**** negative-binomial-distribution
- Parameters: successes, probability, failuresp
- Estimators: negative-binomial-distribution-estimate-unbiased,
    negative-binomial-distribution-estimate-maximum-likelihood
- When failuresp is NIL, the distribution is supported on k = s, s+1, ...
  (the # of trials until a given number of successes, inclusive))
- When failuresp is T (the default), it is supported on k = 0, 1, ...
  (the # of failures until a given number of successes, inclusive)
- Estimators also have the failuresp parameter
- (Variant: geometric-distribution [successes = 1, failuresp = nil])
**** normal-distribution
- Parameters: expected-value, deviation
- Estimators: normal-distribution-estimate-unbiased,
    normal-distribution-estimate-maximum-likelihood
- (Variant: standard-normal-distribution)
**** poisson-distribution
- Parameters: rate
**** t-distribution
- Parameters: degree
- Estimators: [none]
**** uniform-distribution
- Parameters: from, to
- Estimators: uniform-distribution-estimate-moments,
    uniform-distribution-estimate-maximum-likelihood
- (Variant: standard-uniform-distribution)
**** weibull-distribution
- Parameters: scale, shape
*** Distribution tests
**** normal-dist-test
- Input: frequation sequence, infimum of the first class, class width, precision
- Output( 3 values of property-list )
    - result (:TOTAL total-frequency :MEAN mean :VARIANCE variance :SD standard-deviation)
    - table (:MID mid-value-of-each-class :FREQ frequency-of-each-class :Z standard-score :CDF cummulative-distribution-frequency :EXPECTATION expectation)
    - result2 (:CHI-SQ Chi-square-statistics :D.F. Degree-of-freedom :P-VALUE p-value)
**** poisson-dist-test
- Input: sequence of frequency
- Output( 3 values of p-list )
    - result (:N total-frequency :MEAN mean)
    - table (:C-ID assumed-class-value :FREQ frequency :P probability :E expectation)
    - result2 (:CHI-SQ Chi-square-statistics :D.F. Degree-of-freedom :P-VALUE p-value)
**** binom-dist-test
- Input: sequence of frequency, sequence of class-value, size of Bernoulli trials
- Output( 3 values of p-list )
    - result (:D-SIZE total-frequency :PROBABILITY population-rate)
    - table (:FREQ frequency :P probability :E expectation)
    - result2 (:CHI-SQ Chi-square-statistics :D.F. Degree-of-freedom :P-VALUE p-value)

*** Outlier verification
**** smirnov-grubbs (seq alpha &key (type :max) (recursive nil))
Smirnov-Grubbs method for outlier verification.
- return: nil | sequence
- arguments:
  - seq   : <sequence of number>
  - alpha : <number> , significance level
  - type  : :min | :max, which side of outlier value
  - recursive : nil | t
- reference: http://aoki2.si.gunma-u.ac.jp/lecture/Grubbs/Grubbs.html

*** Sample listener log
**** QUOTE Loading without ASDF
(assuming you are in the directory where the library resides)
CL-USER> (load "package")
T
CL-USER> (load "utilities")
T
CL-USER> (load "math")
T
CL-USER> (load "statistics")
T
CL-USER> (load "distribution-test")
T
CL-USER> (in-package :statistics)
#<PACKAGE "STATISTICS">
STAT> 
**** QUOTE Loading with ASDF
(assuming that the path to statistics.asd is in ASDF:*CENTRAL-REGISTRY*)
CL-USER> (asdf:operate 'asdf:load-op 'statistics)
; loading system definition from ~/.sbcl/systems/statistics.asd
; into #<PACKAGE "ASDF0">
; registering #<SYSTEM :STATISTICS {B65C489}> as STATISTICS
NIL
CL-USER> (in-package :statistics)
#<PACKAGE "STATISTICS">
STAT> 
**** Simple usage (examples taken from "Lisp-Statによる統計解析入門" by 垂水共之)
***** QUOTE One-valued data
STAT> (defparameter height '(148 160 159 153 151 140 156 137 149 160 151 157 157 144))
HEIGHT
STAT> (mean height)
1061/7
STAT> (+ (mean height) 0.0d0)
151.57142857142858d0
STAT> (median height)
152
STAT> (five-number-summary height)
(137 297/2 152 157 160)
STAT> (mapcar (lambda (x) (discrete-quantile height x)) '(0 1/4 1/2 3/4 1))
(137 297/2 152 157 160)
STAT> (interquartile-range height)
17/2
STAT> (+ (mean-deviation height) 0.0d0)
5.857142857142857d0
STAT> (+ (variance height) 0.0d0)
50.10204081632653d0
STAT> (standard-deviation height)
7.345477789500419d0
STAT> 
***** QUOTE Two-valued data
STAT> (defparameter weight '(41 49 45 43 42 29 49 31 47 47 42 39 48 36))
WEIGHT
STAT> (linear-regression height weight)
(-70.15050916496945d0 0.7399185336048879d0)
STAT> (+ (covariance height weight) 0.0d0)
39.92307692307692d0
STAT> (correlation-coefficient height weight)
0.851211920646571d0
STAT> (defparameter baseball-teams '((3 2 1 5 4 6) (2 6 3 5 1 4))
	"Six baseball teams are ranked by two people in order of liking.")
BASEBALL-TEAMS
STAT> (+ (apply #'spearman-rank-correlation baseball-teams) 0.0d0)
0.02857142857142857d0
STAT> (+ (apply #'kendall-rank-correlation baseball-teams) 0.0d0)
-0.06666666666666667d0
STAT> 
***** QUOTE Distributions
STAT> (quantile (standard-normal-distribution) 0.025d0)
-1.9599639551896222d0
STAT> (density (standard-uniform-distribution) 1.5d0)
0
STAT> (cdf (standard-uniform-distribution) 0.3d0)
0.3d0
STAT> (defparameter normal-random (rand-n (standard-normal-distribution) 1000))
NORMAL-RANDOM
STAT> (five-number-summary normal-random)
(-3.048454339464769d0 -0.6562483981626692d0 -0.0378855048937908d0
 0.6292440569288786d0 3.3461196116924925d0)
STAT> (mean normal-random)
-0.003980893528421081d0
STAT> (standard-deviation normal-random)
0.9586638291006542d0
STAT> (quantile (t-distribution 5) 0.05d0)
-2.0150483733330242d0
STAT> (density (t-distribution 10) 1.0d0)
0.23036198922913856d0
STAT> (defparameter chi-random (rand-n (chi-square-distribution 10) 1000))
CHI-RANDOM
STAT> (mean chi-random)
10.035727383909936d0
STAT> (standard-deviation chi-random)
4.540307733714504d0
STAT> 
***** QUOTE Distribution tests (examples taken from http://aoki2.si.gunma-u.ac.jp/R/)
STAT(6): (normal-dist-test '(4 19 86 177 105 33 2) 40 5 0.1)
(:TOTAL 426 :MEAN 57.931225 :VARIANCE 26.352928 :SD 5.13351)
(:MID (37.45 42.45 47.45 52.45 57.45 62.45 67.45 72.45 77.45) :FREQ
(0 4 19 86 177 105 33 2 0) :Z
(-3.5027153 -2.5287228 -1.5547304 -0.58073795 0.3932545 1.3672462
 2.3412387 3.315231 4.2892237)
:CDF
(2.3027066827641107d-4 0.005493650023016494d0 0.0542812231219722d0
 0.2207033969433026d0 0.3722256949242654d0 0.2612916822967053d0
 0.07616414571442975d0 0.009152099332533692d0 4.578369754981715d-4)
:EXPECTATION
(0.09809530468575112d0 2.4383902144907776d0 23.123801049960157d0
 94.01964709784691d0 158.56814603773705d0 111.31025665839645d0
 32.44592607434708d0 4.093832867221574d0 0.19503855156222105d0))
(:CHI-SQ 6.000187256825313d0 :D.F. 4 :P-VALUE 0.19913428945535006d0)

STAT(10): (poisson-dist-test '(27 61 77 71 54 35 20 11 6 2 1))
(:N 365 :MEAN 1092/365)
(:C-ID (0 1 2 3 4 5 6 7 8 9 ...) :FREQ (27 61 77 71 54 35 20 11 6 2 ...)
 :P
 (0.050197963 0.1501813 0.22465476 0.22403927 0.1675691 0.100266
  0.04999565 0.021368004 0.0079910485 0.002656385 ...)
 :E
 (18.322256 54.816174 81.998985 81.77434 61.162724 36.59709 18.248411
  7.7993217 2.9167328 0.96958053 ...))
(:CHI-SQ 14.143778 :D.F. 8 :P-VALUE 0.07809402061210624d0)

STAT(16): (binom-dist-test '(2 14 20 34 22 8) '(0 1 2 3 4 5) 5)
                           (binom-dist-test '(2 14 20 34 22 8) '(0 1 2 3 4 5) 5)
(:SIZE 6 :PROBABILITY 0.568)
(:FREQ (2 14 20 34 22 8) :P
 (0.015045918 0.098912984 0.26010454 0.3419893 0.22482634 0.059121) :E
 (1.5045917 9.891298 26.010454 34.198933 22.482634 5.9121003))
(:CHI-SQ 4.007576 :D.F. 4 :P-VALUE 0.4049815220790788d0)
***** QUOTE Outlier verification
STAT(6): (defparameter *sample*
             '(133 134 134 134 135 135 139 140 140 140 141 142 142 144 144 147 147 149 150 164))

STAT(7): (smirnov-grubbs *sample* 0.05 :type :max)
Data: MAX = 164.000
t= 3.005, p-value = 2.557, df = 18

STAT(8): (smirnov-grubbs *sample* 0.05 :type :min)
Data: MIN = 133.000
t= 1.172, p-value = 2.557, df = 18

STAT(11): (smirnov-grubbs *sample* 0.05 :type :max :recursive t)
(133 134 134 134 135 135 139 140 140 140 ...)

STAT(12): (set-difference *sample* *)
(164)
** Notes
- Numbers are not converted to (double) floats, for better accuracy with
  whole number data. This should be OK, since double data will generate
  double results (the number type is preserved).
- Places marked with TODO are not optimal or not finished (see the TODO
  file for more details).
* Test package
The package for test is 'lisp-unit'.
Operation check required: linux32, linux64, win32, sparc/solaris32
** lisp-unit
*** How to use
- 1. Read the documentation in 
   http://www.cs.northwestern.edu/academics/courses/325/readings/lisp-unit.html

- 2. Make a file of DEFINE-TEST's. See exercise-tests.lisp for many examples. If you want, start your test file with (REMOVE-TESTS) to clear any previously defined tests.

- 2. (use-package :lisp-unit)

- 3. Load your code file and your file of tests.

- 4. Test your code with (RUN-TESTS test-name1 test-name2 ...) -- no quotes! -- or simply (RUN-TESTS) to run all defined tests.

- A summary of how many tests passed and failed will be printed, with details on the failures.

- Note: Nothing is compiled until RUN-TESTS is expanded. Redefining functions or even macros does not require reloading any tests.
** STEFIL
- http://common-lisp.net/project/stefil/

* Licensing

CLML is licensed under the terms of the Lisp Lesser GNU Public
License, known as the LLGPL and distributed with CLML as the
file "LICENSE". The LLGPL consists of a preamble and the LGPL, which
is distributed with CLML as the file "LGPL". Where these
conflict, the preamble takes precedence.

The LGPL is also available online at:  http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

The LLGPL is also available online at:  http://opensource.franz.com/preamble.html





