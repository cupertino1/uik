﻿&НаСервере
Функция КнопкаВыполнитьНажатие_Сервер(ДвоичныеДанныеАдрес)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДвоичныеДанныеАдрес);
	имяФайла = ПолучитьИмяВременногоФайла(".xml");
	ДвоичныеДанные.Записать(имяФайла);
	
	Чтение = Новый ЧтениеXML; 
	Чтение.ОткрытьФайл(имяФайла);	
	
	ДатаКотировки = ТекущаяДата();
	
	Пока Чтение.Прочитать() Цикл
 
        Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
            ИмяУзла = Чтение.Имя; 
			
			Если СокрЛП(ИмяУзла) = "instrument" Тогда
				ЗаписьРазрешена = Ложь;
			КонецЕсли;
			
        КонецЕсли;
 
		Если Чтение.ТипУзла = ТипУзлаXML.Текст Тогда
			Значение = Чтение.Значение;
			
            Если СокрЛП(ИмяУзла) = "estimation_date" Тогда    						
                ДатаКотировки = ПреобрСтроковойДаты(Значение);	
			КонецЕсли; 
			
			Если СокрЛП(ИмяУзла) = "isin" Тогда
				ISIN = СокрЛП(Значение);
				ЦБ = Справочники.ЦенныеБумаги.НайтиПоРеквизиту("уи_ISIN", ISIN);
				Если ЦБ = "" Или ЦБ = ПредопределенноеЗначение("Справочник.ЦенныеБумаги.ПустаяСсылка") Тогда
					Сообщить("Ценная бумага с кодом ISIN = " + ISIN + " не найдена!!!");
					ЗаписьРазрешена = Ложь;
				Иначе
					Если ЦБ.уи_ОбщийТип = ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.АкцииОбыкновенные") Или ЦБ.уи_ОбщийТип=ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.АкцииПривилегированные") Тогда
						ТипЦБ = "акция";
					ИначеЕсли ЦБ.уи_ОбщийТип=ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.КорпоративныеОблигации") Или ЦБ.уи_ОбщийТип=ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.ГосударственныеОблигацииСубъктаФедерации") 
						Или ЦБ.уи_ОбщийТип=ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.КорпоративныеОблигацииИностр") Или ЦБ.уи_ОбщийТип=ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.МуниципальныеОблигации") 
						Или ЦБ.уи_ОбщийТип=ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.ФедеральныеГосударственныеОблигации") Или ЦБ.уи_ОбщийТип=ПредопределенноеЗначение("Справочник.уи_ОбщиеТипыЦенныхБумаг.ОблигацииСИпотечнымПокрытием") Тогда  
						ТипЦБ = "облигация";	  
					КонецЕсли;
					ЗаписьРазрешена = Истина;
				КонецЕсли;	
			КонецЕсли;	

			Если СокрЛП(ИмяУзла) = "rate" Тогда
				Котировка = СокрЛП(Значение); 
				
			КонецЕсли;
		
			Если СокрЛП(ИмяУзла) = "cur_code" Тогда
				КодВалюты = СокрЛП(Значение);							
			КонецЕсли;
        КонецЕсли;
 
		Если Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда 
			Если СокрЛП(Чтение.Имя) = "instrument" и ЗаписьРазрешена и ЦБ <> ПредопределенноеЗначение("Справочник.ЦенныеБумаги.ПустаяСсылка") Тогда
				
				// пишем котировку...
				
				Если ТипЦБ = "облигация" Тогда
    				Номинал = РегистрыСведений.уи_НоминалЦенныхБумаг.ПолучитьПоследнее(ДатаКотировки, Новый Структура("ЦеннаяБумага", ЦБ)).Сумма;
    				Если Номинал > 0 Тогда
    					Котировка = Котировка/100*Номинал;
    				Иначе
    					Котировка = Котировка*10;
    				КонецЕсли;
				КонецЕсли;
				
				Для Каждого Стр Из Объект.ВидыКотировок Цикл
    					
    				Если Стр.ВидКотировки.ТипКотировки = ПредопределенноеЗначение("Перечисление.уи_ТипыКотировок.расчетная") Тогда
    	
    					Если Стр.Загружать = Истина И Число(Котировка) > 0 Тогда
    						Элемент = РегистрыСведений.уи_КотировкиЦенныхБумаг.СоздатьМенеджерЗаписи();
    						Элемент.Период = ДатаКотировки;
							Валюта = Справочники.Валюты.НайтиПоНаименованию(КодВалюты);
							Если Валюта = Справочники.Валюты.ПустаяСсылка() и КодВалюты = "RUB" Тогда
								Валюта = Справочники.Валюты.НайтиПоНаименованию("руб.");
							КонецЕсли;	
    						Элемент.Валюта = Валюта;
    						Элемент.ВидКотировки = Стр.ВидКотировки;
    						Элемент.ЗначениеКотировки = Котировка;
    						Элемент.ЦеннаяБумага = ЦБ;
    						Элемент.Записать(Истина);
    					КонецЕсли;
    					
    				КонецЕсли;
    				
				КонецЦикла;
				ЗаписьРазрешена = Ложь;
			КонецЕсли;
						
            ИмяУзла = "";
        КонецЕсли; 
 
	КонецЦикла;
	
	Чтение.Закрыть();
 КонецФункции

&НаКлиенте
Процедура КнопкаВыполнитьНажатие(Команда)
	Адрес="";
	ДвоичныеДанныеАдрес = ПоместитьФайл(Адрес, Объект.ПутьКФайлу, Объект.ПутьКФайлу, Ложь);
	КнопкаВыполнитьНажатие_Сервер(Адрес);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Формат XML(*.xml)|*.xml";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.ПутьКФайлу = ДиалогОткрытияФайла.ПолноеИмяФайла;
		Элементы.ОсновныеДействияФормыВыполнить.Доступность = 1;	
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ПреобрСтроковойДаты(Значение)
	
	Ст = "";
	Стр = Значение;
	
	Если Найти(Стр, " ") = 0 Тогда
		
		Для Поле = 1 По СтрЧислоВхождений(Стр, "-") + 1 Цикл
			
			Позиция = Найти(Стр, "-");
			
			Если Позиция <> 1 Тогда
				Строка = Сред(Стр, 1, Позиция - 1);
				Ст = Ст + Строка;
			КонецЕсли;
			
			Стр = Сред(Стр, Позиция + 1, СтрДлина(Стр));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат(Дата(Ст));
	
КонецФункции

&НаСервере
Функция ПриОткрытии_Сервер()
	Объект.ПутьКФайлу = ХранилищеСистемныхНастроек.Загрузить("ПутьКФайлу2");
КонецФункции

&НаСервере
Функция ПриОткрытии_Сервер_1()	
	Если Объект.ВидыКотировок.Количество() = 0 Тогда
		
		ВыборкаСпр = Справочники.уи_ВидыКотировок.Выбрать();
		
		Пока ВыборкаСпр.Следующий() Цикл
			
			Если ВыборкаСпр.ТипКотировки=ПредопределенноеЗначение("Перечисление.уи_ТипыКотировок.расчетная")   
				 Тогда
				 
				 НоваяСтрока = Объект.ВидыКотировок.Добавить();
				 
				 НоваяСтрока.ВидКотировки = ВыборкаСпр.Ссылка;
				 НоваяСтрока.Загружать = Истина;
				 
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытии_Сервер();
КонецПроцедуры

&НаСервере
Функция ПередЗакрытием_Сервер()
	ХранилищеСистемныхНастроек.Сохранить("ПутьКФайлу2",, Объект.ПутьКФайлу);
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ПередЗакрытием_Сервер();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПоискЦБ = 2;
	ПриОткрытии_Сервер();
	ПриОткрытии_Сервер_1();
КонецПроцедуры