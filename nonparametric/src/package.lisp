
(defpackage :clml.nonparameteric.statistics
  (:nicknames :nonparameteric.statistics :nonpara.stat)
  (:use :cl :hjs.util.matrix :hjs.util.vector :hjs.util.meta)
  (:export :make-adarray
   
	   :unit-random
	   :bernoulli
	   :exp-random
	   :beta-random
	   :gamma-random
	   :normal-random
	   :normal-density
	   :chi-square-random
	   :randomize-choice
	   :randomize-slice
	   :jackup-logged-prob
	   :shuffle-vector
	   :random-elt
	   :normalize!
	   :get-n-best
	   :safe-exp
	   :safe-expt
	   :stirling-number
	   :dirichlet-random
	   :binomial-random
	   :cauchy-random

	   :gamma-function
	   :beta-function
	   :loggamma
	   :digamma
	   :trigamma
	   
	   :multivariate-normal-density
	   :%multivariate-normal-density
	   :multivariate-normal-logged-density
	   :%multivariate-normal-logged-density
	   :multivariate-normal-random
	   :LUed-wishart-random

	   :outer-product
	   :map-matrix-cell
	   :map-matrix-cell!
	   :crossproduct
	   :cholesky-decomp
	   
	   :*most-negative-exp-able-float*
	   :*most-positive-exp-able-float*
	   
	   :*randomize-trace*))


(defpackage :clml.nonparametric.dpm
  (:nicknames :dpm :nonparametric.dpm)
  (:use :cl
        :hjs.util.meta
        :hjs.util.matrix
        :hjs.util.vector
        :nonpara.stat)
  (:export :dpm
	   :dpm-k
	   :dpm-p
	   :dpm-base
	   :dpm-clusters
	   :dpm-hyper
	   :dpm-data
	   :dpm-cluster-layers
	   :estimate-base?
	   
	   :logged-dpm
	   
	   :point
	   :make-point
	   :point-data
	   :point-cluster
	   
	   :cluster
	   :gaussian-cluster
	   :cluster-size
	   :cluster-center
	   :cluster-std
	   
	   :dp-distribution
	   :dp-gaussian
	   :cluster-class
	   :average-of-average
	   :std-of-average
	   
	   :gauss-dpm
	   
	   :density-to-cluster
	   :base-distribution
	   :make-new-cluster
	   :sample-cluster-parameters
	   :sample-distribution
	   
	   :add-customer
	   :remove-customer
	   :add-to-cluster
	   :remove-from-cluster
	   
	   :cluster-rotation
	   
	   :initialize
	   :sampling
	   :seatings-sampling
	   :parameters-sampling
	   :hypers-sampling
	   
	   :make-cluster-result
	   :head-clusters
	   
	   :*hyper-base-a*
	   :*hyper-base-b*

        :multivar-gaussian-cluster
	   :multivar-gauss-dpm
	   :multivar-dp-gaussian
       ))

(defpackage :clml.nonparametric.hdp-lda
  ;; (:nicknames :hdp-lda :text.hdp-lda)
  (:use :cl :nonparameteric.statistics :hjs.util.meta)
  (:export :hdp-lda
	   :word
	   :document
	   :table
	   
	   :document-id
	   :document-words
	   :document-thetas
	   
	   :word-id
	   
	   :topic-count
	   :hdp-lda-data
	   :vocabulary
	   
	   :add-customer
	   :remove-customer
	   :sample-new-topic
	   :hypers-sampling
	   
	   :initialize
	   :sampling
	   :assign-theta
	   :get-phi
	   
	   :get-top-n-words
	   :revert-word
	   
	   :*alpha-base-a*
	   :*alpha-base-b*
	   :*gamma-base-a*
	   :*gamma-base-b*
	   
	   :*default-beta*)
  (:documentation "Package for Latent-Dirichlet-Allocation by Hierarchical-Dirichlet-Process

*** sample usage
#+INCLUDE: \"../sample/svm-validation.org\"  example lisp 
")
  )

(defpackage :clml.nonparametric.hdp
  (:nicknames :nonparametric.hdp)
  (:use :cl :hjs.util.meta :nonpara.stat :nonparametric.dpm)
  (:export :hdp-cluster
	   :cluster-latent-table
	   :cluster-tmp-table
	   :cluster-beta
	   
	   :hdp
	   :hdp-gamma
	   :hdp-beta
	   
	   :sample-latent-table
	   
	   :hdp-distribution
	   
	   :sliced-hdp
	   ))

(defpackage :clml.nonparametric.hdp-hmm
  (:nicknames :nonparametric.hdp-hmm)
  (:use :cl)
  (:import-from :clml.nonparametric.dpm
                :gaussian-cluster
                )
  (:export :gaussian-state
	   :gauss-hdp-hmm
	   :state-gaussian
	   
	   :make-sticky-test))

(defpackage :clml.nonparametric.sticky-hdp-hmm
  (:nicknames :nonparametric.sticky-hdp-hmm)
  (:use :cl :nonpara.stat :hjs.util.meta
	:nonparametric.dpm
	:nonparametric.hdp
	:nonparametric.hdp-hmm)
  (:export :sticky-hdp-hmm
	   :sticky-hidden-state
	   :sticky-state-uniform
	   
	   :sticky-kappa
	   
	   :*rho-base-c*
	   :*rho-base-d*))

(defpackage :clml.nonparametric.blocked-hdp-hmm
  (:nicknames nonparametric.blocked-hdp-hmm)
  (:use :cl :nonpara.stat :hjs.util.meta
	:nonparametric.dpm 
	:nonparametric.hdp
	:nonparametric.hdp-hmm)
  (:export :blocked-hidden-state
	   :blocked-hdp-hmm
	   :block-uniform
	   
	   :point-sequence
	   :sequence-data
	   :seq-point
	   
	   :sampling-pi
	   
	   :sorted-before
	   :hdp-hmm-l
	   :state-pi))

(defpackage :clml.nonparametric.ihmm
  (:nicknames :nonparametric.ihmm)
  (:use :cl :hjs.util.meta
	:nonpara.stat
	:nonparametric.dpm
	:nonparametric.hdp
	:nonparametric.hdp-hmm
	:nonparametric.sticky-hdp-hmm
	:nonparametric.blocked-hdp-hmm)
  (:export :ihmm
	   :ihmm-state
	   :ihmm-state-uniform))


(defpackage :clml.nonparametric.hdp-hmm
  (:nicknames :nonparametric.hdp-hmm)
  (:use :cl
        :hjs.util.meta
        :clml.nonparameteric.statistics
        :clml.nonparametric.dpm
        :clml.nonparametric.hdp)
  (:export :hidden-state
           :emission

           :hdp-hmm
           :vocabulary
           :hdp-hmm-eos

           :cluster-dist-table
           :trans-prob
           :emission-prob

           :state-uniform

           :make-pattern-data
           :make-repeat-pattern
           :show-hidden-states

           :*smooth-beta*
           ))

(defpackage :clml.nonparametric.ftm
  (:nicknames :nonparametric.ftm)
  (:use :cl
        :clml.nonparameteric.statistics
        :clml.nonparametric.dpm)
  (:export :ftm-topic
	   :topic-pi
	   :topic-phi
	   
	   :document
	   
	   :ftm
	   :ftm-ibp-alpha	  
	   
	   :ftm-uniform

	   :get-top-n-words
   ))

(defpackage :clml.nonparametric.lfm
  (:nicknames :nonparametric.lfm)
  (:use :cl :nonpara.stat :hjs.util.meta
	:hjs.util.matrix :hjs.util.vector
	:nonparametric.dpm)
  (:export :ibp
	   :ibp-row
	   :ibp-distribution
	   
	   :lfm
	   
	   :lfm-row
	   :row-weight
	   
	   :lfm-distribution
	   
	   ))
