using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.ArtikalStateMachine;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.NarudzbaStateMachine;
using eKucniLjubimci.Services.ZivotinjaStateMachine;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.CodeDom;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class ZivotinjaService : BaseServiceCRUD<DtoZivotinja, Zivotinja, SearchZivotinja, AddZivotinja, UpdateZivotinja>, IZivotinjaService
    {
        BaseZivotinjaState _baseZivotinjaState;
        public ZivotinjaService(DataContext context, IMapper mapper, BaseZivotinjaState baseZivotinjaState) : base(context, mapper)
        {
            _baseZivotinjaState= baseZivotinjaState;
        }
        public override IQueryable<Zivotinja> AddInclude(IQueryable<Zivotinja> data, SearchZivotinja? search)
        {
            data = data.Include(x => x.Vrsta).ThenInclude(x=>x.Rasa).Include(x => x.Slike).OrderByDescending(x=>x.DatumPostavljanja);

            return base.AddInclude(data, search);
        }
        public override async Task<DtoZivotinja> GetById(int id)
        {
            var data = await _context.Set<Zivotinja>().Include(x=>x.Vrsta).ThenInclude(x => x.Rasa).Include(x=>x.Slike).FirstOrDefaultAsync(x=>x.ZivotinjaId==id);

            return _mapper.Map<DtoZivotinja>(data);
        }
        public override IQueryable<Zivotinja> AddFilter(IQueryable<Zivotinja> data, SearchZivotinja? search)
        {
            data = data.Where(x => x.StateMachine != "Deleted").Where(x=>x.Slike.Count>0);
            if (!string.IsNullOrWhiteSpace(search.Rasa))
            {
                data = data.Where(x => x.Vrsta.Rasa.Naziv.ToLower().Contains(search.Rasa.ToLower()));
            }
            if (!string.IsNullOrWhiteSpace(search.Vrsta))
            {
                data = data.Where(x => x.Vrsta.Naziv.Contains(search.Vrsta));
            }
            if (!string.IsNullOrWhiteSpace(search.Naziv))
            {
                data = data.Where(x => x.Naziv.Contains(search.Naziv));
            }
            if (search.CijenaDo != null && search.CijenaDo != 0)
            {
                data = data.Where(x => x.Cijena <= search.CijenaDo);
            }
            if (search.CijenaOd != null && search.CijenaOd != 0)
            {
                data = data.Where(x => x.Cijena >= search.CijenaOd);
            }
            if (search.Dostupnost==true)
            {
                data = data.Where(x => x.Dostupnost == search.Dostupnost);
            }
            if (search.VrstaId!=null)
            {
                data = data.Where(x => x.VrstaId == search.VrstaId);
            }
            return base.AddFilter(data, search);
        }

        public override async Task<DtoZivotinja> Add(AddZivotinja addRequest)
        {
            var state = _baseZivotinjaState.GetState(addRequest.StateMachine);
            return await state.Add(addRequest);
        }

        public override async Task<DtoZivotinja> Update(int id, UpdateZivotinja updateRequest)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Update(id, updateRequest);
        }

        public async Task<DtoZivotinja> Activate(int id)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Activate(id);
        }

        public async Task<DtoZivotinja> Delete(int id)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Delete(id);
        }

        public async Task<List<string>> AllowedActions(int zivotinjaId)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(zivotinjaId);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.AllowedActionsInState();
        }

        public async Task<DtoZivotinja> Dostupnost(int id, bool dostupnost)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Dostupnost(id, dostupnost);
        }


        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<DtoArtikal> Recommend(int id)
        {
            lock (isLocked)
            {
                mlContext = new MLContext();

                var dataDB = _context.Narudzbe
                    .Include(x => x.Zivotinje).ThenInclude(x => x.Slike)
                    .Include(x => x.Zivotinje).ThenInclude(x => x.Vrsta)
                    .Include(x => x.NarudzbeArtikli).ThenInclude(x => x.Artikal).ThenInclude(x => x.Slike).ToList();

                var data = new List<ProductEntry>();

                foreach (var narudzba in dataDB)
                {
                    if (narudzba.Zivotinje.Count > 0 && narudzba.NarudzbeArtikli.Count > 0)
                    {
                        foreach (var artikal in narudzba.NarudzbeArtikli)
                        {
                            foreach (var zivotinja in narudzba.Zivotinje)
                            {
                                data.Add(new ProductEntry()
                                {
                                    ProductID = (uint)zivotinja.Vrsta.RasaId,
                                    CoPurchaseProductID = (uint)artikal.ArtikalId,
                                });
                            }
                        }
                        
                    }
                }

                var trainData = mlContext.Data.LoadFromEnumerable(data);

                //STEP 3: Your data is already encoded so all you need to do is specify options for MatrxiFactorizationTrainer with a few extra hyperparameters
                //        LossFunction, Alpa, Lambda and a few others like K and C as shown below and call the trainer.
                MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
                options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
                options.LabelColumnName = "Label";
                options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                options.Alpha = 0.0051;
                options.Lambda = 0.025;
                // For better results use the following parameters
                //options.NumberOfIterations = 100;
                //options.C = 0.00001;

                var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                model = est.Fit(trainData);
            }


            var sviArtikli = _context.Artikli.Where(x => x.StateMachine != "Deleted");

            var rezultat = new List<Tuple<Artikal, float>>();

            var zivotinjaFromId = _context.Zivotinje.Include(x=>x.Vrsta).FirstOrDefault(x => x.ZivotinjaId ==id);


            foreach (var artikal in sviArtikli)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);
                var prediction = predictionengine.Predict(
                                         new ProductEntry()
                                         {
                                             ProductID = (uint)zivotinjaFromId.Vrsta.RasaId,
                                             CoPurchaseProductID = (uint)artikal.ArtikalId
                                         });

                rezultat.Add(new Tuple<Artikal, float>(artikal, prediction.Score));
            }

            var finalRezultat = rezultat.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(2).ToList();

            return _mapper.Map<List<DtoArtikal>>(finalRezultat);
        }

    }
    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry
    {
        [KeyType(count: 50)]
        public uint ProductID { get; set; }

        [KeyType(count: 50)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; }
    }
}
