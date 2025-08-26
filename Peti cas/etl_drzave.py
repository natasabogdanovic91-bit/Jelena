#imports
import requests
import pandas as pd
import sqlite3
import json
import sys
import logging #korisno za pracenje sta se desava u programu, testiranje i lakse pronalazenje i otklanjanje greska

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s : %(levelname)s : %(message)s',
    handlers=[
        logging.FileHandler("etl_drzave.log"), #upisuje u fajl
        logging.StreamHandler() #prikazuje u konzoli logove
    ]
)

#constants
API_URL = "https://restcountries.com/v3.1/independent?status=true"
DB_FILE = 'etl_drzave.db'

#globalne promenljive
counter = 1

def extract():
    global counter
    logging.info(f"Korak {counter} - Ekstrakcija podataka sa API-ja")
    print(f"Korak {counter} - Ekstrakcija podataka sa API-ja")
    response = requests.get(API_URL)
    response.raise_for_status()
    logging.info(f"Status Code: {response.status_code}")
    counter = counter + 1
    return response.json()
    
def transform(data):
    global counter
    logging.info(f"Korak {counter} - Transformacija podataka")
    df = pd.DataFrame(data)
    
    #filtriram kolone
    kolone = ['name', 'cca2', 'region', 'subregion', 'population', 'area', 'capital']
    df = df[kolone].copy()
    
    df['country_name'] = df['name'].apply(lambda x: x['common'])
    df['capital_city'] = df['capital'].apply(lambda x: x[0])
    
    df = df.drop(columns=['name', 'capital'])
    df = df.rename(columns={'cca2': 'country_code', 'area': 'country_area'})
    
    counter = counter + 1
    
    return df

def load(df):
    global counter
    logging.info(f"Korak {counter} - Ucitavanje podataka u bazu")
    db_connection = sqlite3.connect(DB_FILE)
    table_name = 'countries'
    df.to_sql(table_name, db_connection, if_exists='replace', index=False)
    db_connection.close()
 
 #dodatno nema veze sa ETL
def increment():
    global counter  # Declare 'counter' as global to modify it
    counter += 1
    logging.info(f"Counter inside function: {counter}")

#main funkcija
#poziva ostale funkcije, obavestava korisnika, radi orkestraciju drugih funkcija, itd..
#komunikacija sa korisnikom (opciono)
#1. deo - poziv extract funkcije
#komunikacija sa korisnikom (opciono)
#2. deo - poziv transform funkcije
#komunikacija sa korisnikom (opciono)
#3. deo - poziv load funkcije
#komunikacija sa korisnikom (opciono)

def main():

    unos = input("Da li zelite da zapocnete ETL proces za drzave? da/ne ")
    
    if (unos == "ne"):
        logging.info("Korisnik ne zeli da nastavi proces")
        #prekid programa
        sys.exit("Proces je prekinut odlukom korisnika")
    
    logging.info("Deo 1 - extract")
    
    #extract funkcija
    raw_data = extract()
    
    logging.info("Deo 2 - transform")
    
    #transform funkcija
    clean_data = transform(raw_data)
    
    logging.info("Deo 3 - load")
    
    #load funkcija
    load(clean_data)
    
    logging.info("ETL proces je uspesno zavrsen")
    
    for i in range(10):
        increment()
    

if __name__ == "__main__":
    main()
    
    


