using AutoMapper;

using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.NarudzbaStateMachine.RabbitMQType;
using eKucniLjubimci.Services.Stripe;
using Microsoft.EntityFrameworkCore;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Mail;
using Microsoft.Extensions.Configuration;

namespace eKucniLjubimci.Services.NarudzbaStateMachine
{
    public class ActiveNarudzbaState : BaseNarudzbaState
    {
        private readonly ChargeService _chargeService;
        private readonly CustomerService _customerService;
        public ActiveNarudzbaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider, ChargeService chargeService, CustomerService customerService) : base(context, mapper, serviceProvider)
        {
            _chargeService = chargeService;
            _customerService = customerService;
        }

        public override async Task<List<string>> AllowedActionsInState()
        {
            var actions =await base.AllowedActionsInState();
            actions.Add("Cancel");
            actions.Add("StripePayment");
            actions.Add("StripeCustomer");
            actions.Add("Delete");
            return actions;
        }

        public override async Task<DtoNarudzba> Cancel(int narudzbaId)
        {
            var dbObj = await _context.Set<Narudzba>().FindAsync(narudzbaId);

            dbObj.StateMachine = "Draft";

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqNarudzba>(dbObj);
            mappedEntity.Funkcija = "Cancel";            

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je otkazana narudzba \n-Id: {mappedEntity?.NarudzbaId} \n-Id kupca: {mappedEntity?.KupacId} \n-Datum: {mappedEntity?.DatumNarudzbe}";

            rmqMail.RabbitMQSend(message);

            return _mapper.Map<DtoNarudzba>(dbObj);
        }
        public override async Task<StripePayment> StripePayment(AddStripePayment payment, int narudzbaId, CancellationToken ct)
        {
            var narudzba = await _context.Narudzbe.Include(x => x.Zivotinje).Include(x=>x.Kupac).FirstOrDefaultAsync(x => x.NarudzbaId == narudzbaId);
            var kupac = await _context.Kupci.Include(x => x.Osoba).FirstOrDefaultAsync(x => x.KupacId == narudzba.KupacId);
            ChargeCreateOptions paymentOptions = new ChargeCreateOptions
            {
                Customer = payment.CustomerId,
                ReceiptEmail = payment.ReceiptEmail,
                Description = payment.Description,
                Currency = payment.Currency,
                Amount = (long)(narudzba.TotalFinal*100)
            };

            var createdPayment = await _chargeService.CreateAsync(paymentOptions, null, ct);

            narudzba.StateMachine = "Done";
            kupac.BrojNarudzbi++;
            if (narudzba.Zivotinje.Count() > 0)
            {
                foreach (var zivotinja in narudzba.Zivotinje)
                {
                    zivotinja.StateMachine = "Sold";
                }
            }
            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqNarudzba>(narudzba);
            mappedEntity.Funkcija = "StripePayment";

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je placena narudzba \n-Id: {mappedEntity?.NarudzbaId} \n-Id kupca: {mappedEntity?.KupacId} \n-Datum: {mappedEntity?.DatumNarudzbe}";

            rmqMail.RabbitMQSend(message);

            return new StripePayment(
              createdPayment.CustomerId,
              createdPayment.ReceiptEmail,
              createdPayment.Description,
              createdPayment.Currency,
              createdPayment.Amount,
              createdPayment.Id);
        }
        //-----------------------------------------------------------------------------------------------------------------------------------------------------
        //-----------------------------------------------------------------------------------------------------------------------------------------------------
        public override async Task<DtoNarudzba> Payment(int narudzbaId)
        {
            var narudzba = await _context.Narudzbe.Include(x => x.Zivotinje).Include(x => x.Kupac).FirstOrDefaultAsync(x => x.NarudzbaId == narudzbaId);
            var kupac = await _context.Kupci.Include(x => x.Osoba).FirstOrDefaultAsync(x => x.KupacId == narudzba.KupacId);      

            narudzba.StateMachine = "Done";
            kupac.BrojNarudzbi++;
            if (narudzba.Zivotinje.Count() > 0)
            {
                foreach (var zivotinja in narudzba.Zivotinje)
                {
                    zivotinja.StateMachine = "Sold";
                }
            }
            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqNarudzba>(narudzba);
            mappedEntity.Funkcija = "StripePayment";

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je placena narudzba \n-Id: {mappedEntity?.NarudzbaId} \n-Id kupca: {mappedEntity?.KupacId} \n-Datum: {mappedEntity?.DatumNarudzbe}";

            rmqMail.RabbitMQSend(message);

            return _mapper.Map<DtoNarudzba>(narudzba);
        }

        public override async Task<DtoNarudzba> StripeReference(int narudzbaId,AddReference reference)
        {
            var narudzba = await _context.Narudzbe.Include(x => x.Zivotinje).Include(x => x.Kupac).FirstOrDefaultAsync(x => x.NarudzbaId == narudzbaId);

            narudzba.PaymentId= reference.PaymentId;
            narudzba.PaymentIntent= reference.PaymentIntent;
            
            await _context.SaveChangesAsync();           

            return _mapper.Map<DtoNarudzba>(narudzba);
        }

        //-----------------------------------------------------------------------------------------------------------------------------------------------------
        //-----------------------------------------------------------------------------------------------------------------------------------------------------
        public override async Task<StripeCustomer> StripeCustomer(AddStripeCustomer customer, int narudzbaId, CancellationToken ct)
        {
            CustomerCreateOptions customerOptions = new CustomerCreateOptions
            {
                Name = customer.Name,
                Email = customer.Email,
                Source = customer.Token
            };

            Customer createdCustomer = await _customerService.CreateAsync(customerOptions, null, ct);            

            return new StripeCustomer(createdCustomer.Name, createdCustomer.Email, createdCustomer.Id);
        }

        public override async Task<DtoNarudzba> Delete(int narudzbaId)
        {
            var dbObj = await _context.Set<Narudzba>().FindAsync(narudzbaId);

            dbObj.StateMachine = "Deleted";

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqNarudzba>(dbObj);
            mappedEntity.Funkcija = "Delete";

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je izbrisana narudzba \n-Id: {mappedEntity?.NarudzbaId} \n-Id kupca: {mappedEntity?.KupacId} \n-Datum: {mappedEntity?.DatumNarudzbe}";

            rmqMail.RabbitMQSend(message);

            return _mapper.Map<DtoNarudzba>(dbObj);
        }
    }
}
