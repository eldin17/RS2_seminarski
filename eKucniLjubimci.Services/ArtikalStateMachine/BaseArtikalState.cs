using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.ZivotinjaStateMachine;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ArtikalStateMachine
{
    public class BaseArtikalState
    {
        protected DataContext _context;
        protected IMapper _mapper;
        protected IServiceProvider _serviceProvider;

        public BaseArtikalState(DataContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public BaseArtikalState GetState(string state)
        {
            switch (state)
            {
                case "Initial":
                    return _serviceProvider.GetService<InitialArtikalState>();
                    break;

                case "Draft":
                    return _serviceProvider.GetService<DraftArtikalState>();
                    break;

                case "Active":
                    return _serviceProvider.GetService<ActiveArtikalState>();
                    break;                

                case "Deleted":
                    return _serviceProvider.GetService<DeletedArtikalState>();
                    break;

                default:
                    throw new Exception("Action Not Allowed :(");
            }
        }

        public virtual async Task<DtoArtikal> Add(AddArtikal request)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoArtikal> Update(int id, UpdateArtikal request)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoArtikal> Activate(int id)
        {
            throw new Exception("Action Not Allowed :(");
        }

        public virtual async Task<DtoArtikal> Delete(int id)
        {
            throw new Exception("Action Not Allowed :(");
        }
    }
}
