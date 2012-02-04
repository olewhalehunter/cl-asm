(progn
 (defparameter save-stack@ '((:push %rbp) (:mov %rbp %rsp) (:push %rdi) (:push %rsi) (:push %rbx)))
 (defparameter restore-stack@ '((:pop %rbx) (:pop %rsi) (:pop %rdi) (:pop %rbp)))
 (defparameter in@ save-stack@)
 (defparameter out@ `(,@restore-stack@ :ret))

 (defmacro body (&rest mnemonics)
  `'(,@in@
     ,@mnemonics
     ,@out@))

 ;; ready/destroy data-stack
 (defun ready ()
   '(:progn (:push %rax)
            (:push %rdi)
            (:mov %edi 1024)
            (:mov %rax (:extern "malloc"))
            (:call %rax)
            (:mov %rcx %rax)
            (:pop %rdi)
            (:pop %rax)))

 (defun destroy ()
   '(:progn (:push %rax)
            (:push %rdi)
            (:mov %rdi %rcx)
            (:mov %rax (:extern "free"))
            (:call %rax)
            (:pop %rdi)
            (:pop %rax)))


 ;; registers
 (defparameter %edi '%edi)
 (defparameter %eax '%eax)
 (defparameter %ebx '%ebx)
 (defparameter %edx '%edx)
 (defparameter %ecx '%ecx)
 
 ;; ecx: data-stack
 ;; edx, ebx: temporary

 ;; stack-operation
 (defun @push (dst) ;
   `(:progn (:add %rcx 4)
            (:mov (:refd %rcx) ,dst)))
 
 (defun @pop (dst)  ;
   `(:progn (:mov ,dst (:refd %rcx))
            (:sub %rcx 4)))
 
 (defun @swap () ;; todo: defop
   `(:progn (:mov %ebx (:refd %rcx 0))
            (:mov %edx (:refd %rcx 4))
            (:mov (:refd %rcx 0) %edx)
            (:mov (:refd %rcx 4) %ebx)))
 
 (defun @dup ()
   `(:progn (:mov %ebx (:refd %rcx))
            (:add %rcx 4)
            (:mov (:refd %rcx) %ebx)))
 
 (defun @drop ()
   `(:progn (:sub %rcx 4)))

 (defun @over ()
   `(:progn (:mov %ebx (:refd %rcx 4))
            

 )

(cl-asm:execute
 (body
  $ready$
  (dpush %edi)
  (ddup)
  (dswap)
  (dpop %eax)
  (dpop %eax)
  $destroy$
  )
 (function int int) 30)

;; push
(:mov (:refd %rdi) %eax)
(:add %rdi 4)

;; pop
(:sub %rdi 4)
(:mov %eax (:refd %rdi))

(defparameter *regs*
  '((%al 1 0) (%ax 2 0) (%eax 4 0) (%rax 8 0)
    (%cl 1 1) (%cx 2 1) (%ecx 4 1) (%rcx 8 1)
    (%dl 1 2) (%dx 2 2) (%edx 4 2) (%rdx 8 2)
    (%bl 1 3) (%bx 2 3) (%ebx 4 3) (%rbx 8 3)
    (%ah 1 4) (%sp 2 4) (%esp 4 4) (%rsp 8 4)
    (%ch 1 5) (%bp 2 5) (%ebp 4 5) (%rbp 8 5)
    (%dh 1 6) (%si 2 6) (%esi 4 6) (%rsi 8 6)
    (%bh 1 7) (%di 2 7) (%edi 4 7) (%rdi 8 7)))