using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class StripePayment
    {
        private string Id;

        public StripePayment(string customerId, string receiptEmail, string description, string currency, long amount, string id)
        {
            CustomerId = customerId;
            ReceiptEmail = receiptEmail;
            Description = description;
            Currency = currency;
            Amount = amount;
            PaymentId = id;
        }

        public string CustomerId { get; set; }
        public string ReceiptEmail { get; set; }
        public string Description { get; set; }
        public string Currency { get; set; }
        public decimal Amount { get; set; }
        public string PaymentId { get; set; }
    }
}
