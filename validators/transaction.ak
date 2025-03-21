use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/primitive/string
use cardano/transaction.{OutputReference}

pub type Datum {
  owner: VerificationKeyHash,
  money: Int,
}

pub type Redeemer {
  message: ByteArray,
}

pub type Transaction {
  extra_signatories: List<VerificationKeyHash>,
}

validator trans {
  spend(
    datum: Option<Datum>,
    redeemer: Redeemer,
    _reference: OutputReference,
    tx: Transaction,
  ) {
    expect Some(Datum { owner, money }) = datum
    let hello = redeemer.message == "Hello World"
    trace string.from_bytearray(redeemer.message)
    let ada = money == 12
    let signed = list.has(tx.extra_signatories, owner)
    hello? && signed? && ada?
  }

  else(_) {
    fail
  }
}

test transaction_example() {
  let datum = Datum { owner: #"00000000000000000000000000000000", money: 12 }
  let redeemer = Redeemer { message: "Hello World" }
  let utxo = OutputReference { transaction_id: "", output_index: 0 }
  let tx = Transaction { extra_signatories: [datum.owner] }

  trans.spend(Some(datum), redeemer, utxo, tx)
}
