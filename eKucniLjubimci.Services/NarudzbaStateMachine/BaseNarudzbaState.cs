using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Stripe;
using Microsoft.Extensions.DependencyInjection;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.NarudzbaStateMachine
{
    public class BaseNarudzbaState
    {
        protected DataContext _context;
        protected IMapper _mapper;
        protected IServiceProvider _serviceProvider;

        public BaseNarudzbaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public BaseNarudzbaState GetState(string state)
        {
            switch (state)
            {
                case "Initial":
                    return _serviceProvider.GetService<InitialNarudzbaState>();
                    break;

                case "Draft":
                    return _serviceProvider.GetService<DraftNarudzbaState>();
                    break;

                case "Active":
                    return _serviceProvider.GetService<ActiveNarudzbaState>();
                    break;

                case "Done":
                    return _serviceProvider.GetService<DoneNarudzbaState>();
                    break;

                case "Deleted":
                    return _serviceProvider.GetService<DeletedNarudzbaState>();
                    break;

                default:
                    throw new Exception("Action Not Allowed :(");
            }
        }

        public virtual async Task<List<string>> AllowedActionsInState()
        {
            return new List<string>();
        }

        public virtual async Task<DtoNarudzba> Add(AddNarudzba request)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> AddArtikal(int narudzbaId, int artikalId, int kolicina)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> RemoveArtikal(int narudzbaId, int artikalId)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> AddZivotinja(int narudzbaId, int zivotinjaId)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> RemoveZivotinja(int narudzbaId, int zivotinjaId)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> Update(int narudzbaId, UpdateNarudzba request)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> Activate(int narudzbaId)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> Delete(int narudzbaId)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoNarudzba> Cancel(int narudzbaId)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<StripePayment> StripePayment(AddStripePayment payment, int narudzbaId, CancellationToken ct)
        {
            throw new Exception("Action Not Allowed :(");
        }
        public virtual async Task<DtoNarudzba> Payment(int narudzbaId)
        {
            throw new Exception("Action Not Allowed :(");
        }
        public virtual async Task<StripeCustomer> StripeCustomer(AddStripeCustomer customer, int narudzbaId, CancellationToken ct)
        {
            throw new Exception("Action Not Allowed :(");
        }
        public virtual async Task<DtoNarudzba> StripeReference(int narudzbaId, AddReference reference)
        {
            throw new Exception("Action Not Allowed :(");
        }
    }
}

