using AutoMapper;
using EasyNetQ;
using eKucniLjubimci.Model.DataTransferObjects;
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

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

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

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

            return new StripePayment(
              createdPayment.CustomerId,
              createdPayment.ReceiptEmail,
              createdPayment.Description,
              createdPayment.Currency,
              createdPayment.Amount,
              createdPayment.Id);
        }
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

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

            return _mapper.Map<DtoNarudzba>(dbObj);
        }
    }
}
