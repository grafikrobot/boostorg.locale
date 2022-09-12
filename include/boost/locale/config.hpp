//
// Copyright (c) 2009-2011 Artyom Beilis (Tonkikh)
//
// Distributed under the Boost Software License, Version 1.0.
// https://www.boost.org/LICENSE_1_0.txt

#ifndef BOOST_LOCALE_CONFIG_HPP_INCLUDED
#define BOOST_LOCALE_CONFIG_HPP_INCLUDED

#include <boost/config.hpp>

#if defined(BOOST_ALL_DYN_LINK) || defined(BOOST_LOCALE_DYN_LINK)
#   ifdef BOOST_LOCALE_SOURCE
#       define BOOST_LOCALE_DECL BOOST_SYMBOL_EXPORT
#   else
#       define BOOST_LOCALE_DECL BOOST_SYMBOL_IMPORT
#   endif  // BOOST_LOCALE_SOURCE
#else
#   define BOOST_LOCALE_DECL
#endif // BOOST_LOCALE_DYN_LINK

//
// Automatically link to the correct build variant where possible.
//
#if !defined(BOOST_ALL_NO_LIB) && !defined(BOOST_LOCALE_NO_LIB) && !defined(BOOST_LOCALE_SOURCE)
//
// Set the name of our library, this will get undef'ed by auto_link.hpp
// once it's done with it:
//
#define BOOST_LIB_NAME boost_locale
//
// If we're importing code from a dll, then tell auto_link.hpp about it:
//
#if defined(BOOST_ALL_DYN_LINK) || defined(BOOST_LOCALE_DYN_LINK)
#  define BOOST_DYN_LINK
#endif
//
// And include the header that does the work:
//
#include <boost/config/auto_link.hpp>
#endif  // auto-linking disabled

#if defined(BOOST_LOCALE_HIDE_AUTO_PTR) || defined(BOOST_NO_AUTO_PTR)
#define BOOST_LOCALE_USE_AUTO_PTR 0
#else
#define BOOST_LOCALE_USE_AUTO_PTR 1
#endif

// Check for some C++11 features to provide easier checks for what is missing
// shortly after the requirement of C++11 in Boost 1.81
#if defined(BOOST_NO_CXX11_DEFAULTED_FUNCTIONS) || \
    defined(BOOST_NO_CXX11_DEFAULTED_MOVES) || \
    defined(BOOST_NO_CXX11_HDR_FUNCTIONAL) || \
    defined(BOOST_NO_CXX11_HDR_TYPE_TRAITS) || \
    defined(BOOST_NO_CXX11_NOEXCEPT) || \
    defined(BOOST_NO_CXX11_OVERRIDE) || \
    defined(BOOST_NO_CXX11_RVALUE_REFERENCES) || \
    defined(BOOST_NO_CXX11_SMART_PTR) || \
    defined(BOOST_NO_CXX11_STATIC_ASSERT)
        #error "Boost.Locale requires C++11 since Boost 1.81."
#endif

#ifdef _MSC_VER
// Denote a constant condition, e.g. for if(sizeof(...
#define BOOST_LOCALE_START_CONST_CONDITION __pragma(warning(push)) __pragma(warning(disable : 4127))
#define BOOST_LOCALE_END_CONST_CONDITION __pragma(warning(pop))
#else
#define BOOST_LOCALE_START_CONST_CONDITION
#define BOOST_LOCALE_END_CONST_CONDITION
#endif

#endif // boost/locale/config.hpp

