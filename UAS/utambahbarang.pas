unit uTambahbarang;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, odbcconn, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBCtrls;

type

  { TTfrmTambahBarang }

  TTfrmTambahBarang = class(TForm)
    BSimpan: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBLookupkategori: TDBLookupComboBox;
    EJumlahStok: TEdit;
    EHargaJual: TEdit;
    EHargaBeli: TEdit;
    ENama: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BSimpanClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
     add: boolean

  end;

var
  TfrmTambahBarang: TTfrmTambahBarang;

implementation

{$R *.lfm}

{ TTfrmTambahBarang }
procedure TTfrmTambahBarang.BSimpanClick(Sender: TObject);
begin
  try
    with SQLQuery2 do
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO data_barang (nama, kategori, harga_beli, harga_jual, stok)');
      SQL.Add('VALUES (:nama, (SELECT nama FROM kategori WHERE nama = :kategori), :harga_beli, :harga_jual, :stok)');

      Params.ParamByName('nama').AsString := ENama.Text;
      Params.ParamByName('kategori').AsString := DBLookupkategori.Text; // Assuming DBLookupkategori displays the category name
      Params.ParamByName('harga_beli').AsInteger := StrToInt(EHargaBeli.Text);
      Params.ParamByName('harga_jual').AsInteger := StrToInt(EHargaJual.Text);
      Params.ParamByName('stok').AsInteger := StrToInt(EJumlahStok.Text);
      ExecSQL;
      SQLTransaction1.Commit;

      ENama.Text:='';
      EHargaBeli.Text:='';
      EHargaJual.Text:='';
      EJumlahStok.Text:='';
      add := True;
      ShowMessage('Berhasil menambahkan barang!');
    end;
    SQLQuery1.Open;
  except
    on E: Exception do
       ShowMessage('Terjadi Kesalahan : ' + E.message);
  end;
end;

procedure TTfrmTambahBarang.DataSource1DataChange(Sender: TObject; Field: TField
  );
begin

end;

procedure TTfrmTambahBarang.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if add = True then
  begin
      add := False;
      ModalResult:= mrOk;
  end
  else
      ModalResult:= mrCancel;
end;

procedure TTfrmTambahBarang.FormCreate(Sender: TObject);
begin
  SQLQuery1.Open;
end;

end.

