using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.NarudzbaStateMachine;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ZivotinjaStateMachine
{
    public class BaseZivotinjaState
    {
        protected DataContext _context;
        protected IMapper _mapper;
        protected IServiceProvider _serviceProvider;

        public BaseZivotinjaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public BaseZivotinjaState GetState(string state)
        {
            switch (state)
            {
                case "Initial":
                    return _serviceProvider.GetService<InitialZivotinjaState>();
                    break;

                case "Draft":
                    return _serviceProvider.GetService<DraftZivotinjaState>();
                    break;

                case "Active":
                    return _serviceProvider.GetService<ActiveZivotinjaState>();
                    break;

                case "Reserved":
                    return _serviceProvider.GetService<ReservedZivotinjaState>();
                    break;

                case "Sold":
                    return _serviceProvider.GetService<SoldZivotinjaState>();
                    break;

                case "Deleted":
                    return _serviceProvider.GetService<DeletedZivotinjaState>();
                    break;

                default:
                    throw new Exception("Action Not Allowed :(");
            }
        }

        public virtual async Task<List<string>> AllowedActionsInState()
        {
            return new List<string>();
        }

        public virtual async Task<DtoZivotinja> Add(AddZivotinja request)
        {
            throw new Exception("Action Not Allowed :(");
        }        

        public virtual async Task<DtoZivotinja> Update(int id, UpdateZivotinja request)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoZivotinja> Activate(int id)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoZivotinja> Delete(int id)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoZivotinja> Dostupnost(int id, bool dostupnost)
        {
            throw new Exception("Action Not Allowed :(");
        }
    }
}
