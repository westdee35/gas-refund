;; ------------------------------------------------------------
;; GasRefund Vault - Campaign-based Refund Pools (Clarity v1.0)
;; ------------------------------------------------------------

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-BAD-ARGS (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-INSUFFICIENT (err u103))
(define-constant ERR-ALREADY (err u104))
(define-constant ERR-NOT-DUE (err u105))
(define-constant ERR-NOTHING (err u106))

;; Storage
(define-data-var admin principal tx-sender)
(define-data-var next-campaign-id uint u1)

;; Campaign record
(define-map campaigns
  { id: uint }
  {
    creator: principal,
    min_total: uint,
    multiplier_bps: uint,
    deadline: uint,
    total_contrib: uint,
    payout_pool: uint,
    finalized: bool,
    canceled: bool
  })

;; Contributions per campaign per user
(define-map contributions
  { campaign: uint, user: principal }
  { amount: uint, claimed: bool })

;; Helpers
;; Simulate block height for testnet
(define-read-only (now) u100)

(define-read-only (mul-div (x uint) (num uint) (den uint))
  (if (is-eq den u0) 
      u0 
      (/ (* x num) den)))

(define-private (only-admin)
  (ok (asserts! (is-eq tx-sender (var-get admin)) ERR-UNAUTHORIZED)))

;; Admin functions
(define-public (set-admin (who principal))
  (begin
    (try! (only-admin))
    (asserts! (is-some (some who)) ERR-BAD-ARGS)
    (var-set admin who)
    (ok who)))

;; Campaign lifecycle
(define-public (create-campaign (min-total uint) (multiplier-bps uint) (deadline uint))
  (begin
    (asserts! (> deadline (now)) ERR-BAD-ARGS)
    (asserts! (>= multiplier-bps u0) ERR-BAD-ARGS)
    (asserts! (<= multiplier-bps u10000) ERR-BAD-ARGS)
    (asserts! (> min-total u0) ERR-BAD-ARGS)
    (let ((id (var-get next-campaign-id)))
      (map-set campaigns { id: id }
        {
          creator: tx-sender,
          min_total: min-total,
          multiplier_bps: multiplier-bps,
          deadline: deadline,
          total_contrib: u0,
          payout_pool: u0,
          finalized: false,
          canceled: false
        })
      (var-set next-campaign-id (+ id u1))
      (ok id))))

;; Read-only views
(define-read-only (get-campaign (campaign-id uint))
  (match (map-get? campaigns { id: campaign-id })
    campaign (ok campaign)
    ERR-NOT-FOUND))

(define-read-only (get-contribution (campaign-id uint) (who principal))
  (ok (default-to { amount: u0, claimed: false }
       (map-get? contributions { campaign: campaign-id, user: who }))))

(define-read-only (get-next-campaign-id)
  (ok (var-get next-campaign-id)))